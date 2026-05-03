import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/services/websocket_service.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/data/network/network_constant.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';
import 'package:go_bus_express/models/seat/seat_availability_event.dart';
import 'package:go_bus_express/utils/enums/enum.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/route/select_seat/select_seat_state.dart';
import 'package:shared_package/network/x_result.dart';

import '../../../../repository/route_repository.dart';

class SelectSeatController extends BaseController<SelectSeatState> {
  final RouteRepository _repository;
  final LocalRepository _localRepository;

  final _wsService = WebSocketService();
  StreamSubscription<String>? _messageSub;
  StreamSubscription<ConnectionStatus>? _statusSub;
  String? _currentUserId;
  bool _disposed = false;
  Timer? _heartbeatTimer;

  SelectSeatController(this._repository, this._localRepository)
      : super(SelectSeatState());

  @override
  void onInit() {
    super.onInit();
    print('🚀 [SelectSeat] Controller onInit() called');
    _currentUserId = _resolveUserId();
    // Subscribe before connecting so no status events are missed on a fast connection
    _subscribeToWebSocket();
    _initializeFromArguments();
    _startHeartbeat();
  }

  @override
  void onClose() {
    _disposed = true;
    _heartbeatTimer?.cancel();
    _messageSub?.cancel();
    _statusSub?.cancel();
    _wsService.dispose();
    super.onClose();
  }

  String? _resolveUserId() {
    try {
      final profileJson = _localRepository.getProfile();
      if (profileJson == null) return null;
      final map = jsonDecode(profileJson) as Map<String, dynamic>?;
      return map?['id']?.toString();
    } catch (_) {
      return null;
    }
  }

  // MARK - Initialisation

  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      print('❌ [SelectSeat] No arguments passed to SelectSeatController');
      return;
    }

    final scheduleId = args['scheduleId'] as int?;
    final origin = args['origin'] as String? ?? '';
    final destination = args['destination'] as String? ?? '';
    final departureDate = args['departureDate'] as String?;
    final departureTime = args['departureTime'] as String? ?? '';
    final unitPrice = (args['unitPrice'] as num?)?.toDouble() ?? 0.0;

    print('📋 [SelectSeat] init: scheduleId=$scheduleId');

    updateState(
      (s) => s.copyWith(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
        departureTime: departureTime,
        unitPrice: unitPrice,
        scheduleId: scheduleId ?? 0,
      ),
    );

    if (scheduleId != null) {
      fetchBusSeat(scheduleId);
      _connectWebSocket(scheduleId);
    }
  }

  // MARK - WebSocket

  void _connectWebSocket(int scheduleId) {
    final token = _localRepository.getToken() ?? '';
    
    print('═══════════════════════════════════════════════════════');
    print('🔌 [SelectSeat] CONNECTING TO WEBSOCKET');
    print('═══════════════════════════════════════════════════════');
    
    if (token.isEmpty) {
      print('⚠️ [SelectSeat] No JWT token found! WebSocket will fail to authenticate.');
    } else {
      print('🔌 [SelectSeat] JWT token found (${token.length} chars)');
      print('🔌 [SelectSeat] Token preview: ${token.substring(0, 20)}...');
    }
    
    print('🔌 [SelectSeat] Schedule ID: $scheduleId');
    print('🔌 [SelectSeat] Base URL: ${NetworkConstant.wsBaseUrl}');
    print('🔌 [SelectSeat] Subscribe Topic: ${NetworkConstant.seatTopic(scheduleId)}');
    print('🔌 [SelectSeat] My User ID: $_currentUserId');
    print('═══════════════════════════════════════════════════════');
    
    _wsService.connect(
      baseUrl: NetworkConstant.wsBaseUrl,
      token: token,
      scheduleId: scheduleId,
      subscribeTopic: NetworkConstant.seatTopic(scheduleId),
    );
  }

  void _subscribeToWebSocket() {
    print('🎧 [SelectSeat] Setting up WebSocket listeners...');
    _statusSub = _wsService.connectionStatus.listen(_onStatusChanged);
    _messageSub = _wsService.messages.listen(_onMessageReceived);
    print('✅ [SelectSeat] WebSocket listeners registered');
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      print('💓 [SelectSeat] Heartbeat - Status: ${state.connectionStatus}, '
          'Schedule: ${state.scheduleId}, UserId: $_currentUserId, '
          'Selected: ${state.selectedSeats.length}, '
          'Realtime seats: ${state.realtimeSeats.length}');
    });
  }

  void _onStatusChanged(ConnectionStatus status) {
    print('🔄 [SelectSeat] WebSocket status changed: $status');
    
    // Additional diagnostic info
    if (status == ConnectionStatus.disconnected) {
      print('⚠️ [SelectSeat] Disconnected - This usually means:');
      print('   1. Token is invalid/expired');
      print('   2. Backend rejected the connection');
      print('   3. Check backend logs for authentication errors');
    } else if (status == ConnectionStatus.error) {
      print('❌ [SelectSeat] Error - This usually means:');
      print('   1. Backend server is not running');
      print('   2. Wrong URL: ${NetworkConstant.wsBaseUrl}');
      print('   3. Network/firewall issue');
    } else if (status == ConnectionStatus.connecting) {
      print('🔌 [SelectSeat] Connecting... Please wait');
    } else if (status == ConnectionStatus.connected) {
      print('✅ [SelectSeat] Connected successfully!');
    }
    
    final wasConnected = state.connectionStatus == ConnectionStatus.connected;
    final isNowConnected = status == ConnectionStatus.connected;

    updateState((s) => s.copyWith(
      connectionStatus: status,
      wsErrorMessage: status == ConnectionStatus.error
          ? 'Connection error. Reconnecting...'
          : null,
      clearWsError: status == ConnectionStatus.connected,
    ));

    if (!wasConnected && isNowConnected) {
      print('✅ [SelectSeat] WebSocket connected! Requesting state sync...');
      // Add a small delay to ensure subscription is fully established
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_disposed && _wsService.currentStatus == ConnectionStatus.connected) {
          print('🔄 [SelectSeat] Sending state sync request after connection');
          _requestStateSync();
        }
      });
    }
  }

  void _onMessageReceived(String raw) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    print('');
    print('═══════════════════════════════════════════════════════');
    print('📨 [SelectSeat] MESSAGE RECEIVED AT [$timestamp]');
    print('═══════════════════════════════════════════════════════');
    print('📨 [SelectSeat] Message length: ${raw.length} chars');
    print('📨 [SelectSeat] Full message: $raw');
    print('📨 [SelectSeat] My User ID: $_currentUserId');
    print('📨 [SelectSeat] Schedule ID: ${state.scheduleId}');
    print('═══════════════════════════════════════════════════════');
    
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>?;
      if (json == null) {
        print('⚠️ [SelectSeat] Decoded JSON is null');
        return;
      }
      
      final eventType = json['type'] as String?;
      final seatNumber = json['seatNumber'] as String?;
      final userId = json['userId']?.toString();
      final scheduleId = json['scheduleId'];
      
      print('📨 [SelectSeat] Event type: $eventType');
      print('📨 [SelectSeat] Seat number: $seatNumber');
      print('📨 [SelectSeat] User ID in event: $userId');
      print('📨 [SelectSeat] Schedule ID in event: $scheduleId');
      print('═══════════════════════════════════════════════════════');
      print('');
      
      _routeEvent(SeatAvailabilityEvent.fromJson(json));
    } catch (e, stack) {
      print('⚠️ [SelectSeat] Failed to parse message: $e');
      print('⚠️ [SelectSeat] Stack trace: $stack');
      print('⚠️ [SelectSeat] Raw message was: $raw');
    }
  }

  void _routeEvent(SeatAvailabilityEvent event) {
    print('🔀 [EVENT] Routing event type: ${event.type}');
    switch (event.type) {
      case SeatEventType.seatSelected:
        _handleSeatSelected(event);
      case SeatEventType.seatDeselected:
        _handleSeatDeselected(event);
      case SeatEventType.seatBooked:
        _handleSeatBooked(event);
      case SeatEventType.seatReleased:
        _handleSeatReleased(event);
      case SeatEventType.seatExpired:
        _handleSeatExpired(event);
      case SeatEventType.stateSyncResponse:
        _handleStateSyncResponse(event);
      default:
        print('⚠️ [WS] Unknown event type: ${event.type}');
    }
  }

  void _handleSeatSelected(SeatAvailabilityEvent event) {
    final seatNum = event.seatNumber;
    if (seatNum == null) return;
    
    print('🎯 [SEAT_SELECTED] Seat: $seatNum, EventUserId: ${event.userId}, MyUserId: $_currentUserId');
    print('🎯 [SEAT_SELECTED] Already in my selection: ${state.selectedSeats.contains(seatNum)}');
    print('🎯 [SEAT_SELECTED] Is my own action: ${event.userId == _currentUserId}');
    
    // ALWAYS apply the realtime status - this ensures all devices see the update
    // The UI will handle displaying it correctly based on ownership
    print('✅ [SEAT_SELECTED] Applying realtime status for seat $seatNum by user ${event.userId}');
    _applyRealtimeStatus(seatNum, 'PENDING', event.seatId, event.userId);
    
    // If this is from another user/device, ensure it's not in our local selection
    if (event.userId != _currentUserId && state.selectedSeats.contains(seatNum)) {
      print('⚠️ [SEAT_SELECTED] Another user selected our seat! Removing from local selection');
      final seats = List<String>.from(state.selectedSeats)..remove(seatNum);
      final ids = List<int>.from(state.selectedSeatIds);
      if (event.seatId != null) ids.remove(event.seatId);
      updateState((s) => s.copyWith(selectedSeats: seats, selectedSeatIds: ids));
      
      Get.snackbar(
        'Seat Taken',
        'Seat $seatNum was selected by another user',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _handleSeatDeselected(SeatAvailabilityEvent event) {
    final seatNum = event.seatNumber;
    if (seatNum == null) return;
    
    print('🎯 [SEAT_DESELECTED] Seat: $seatNum, EventUserId: ${event.userId}');
    _applyRealtimeStatus(seatNum, 'AVAILABLE', event.seatId, null);
    
    // If this was in our local selection (shouldn't happen normally), remove it
    if (state.selectedSeats.contains(seatNum)) {
      print('⚠️ [SEAT_DESELECTED] Removing from local selection');
      final seats = List<String>.from(state.selectedSeats)..remove(seatNum);
      final ids = List<int>.from(state.selectedSeatIds);
      if (event.seatId != null) ids.remove(event.seatId);
      updateState((s) => s.copyWith(selectedSeats: seats, selectedSeatIds: ids));
    }
  }

  void _handleSeatBooked(SeatAvailabilityEvent event) {
    final seatNum = event.seatNumber;
    if (seatNum == null) return;
    
    print('🎯 [SEAT_BOOKED] Seat: $seatNum, EventUserId: ${event.userId}');
    _applyRealtimeStatus(seatNum, 'BOOKED', event.seatId, null);
    
    // Remove from local selection if present
    if (state.selectedSeats.contains(seatNum)) {
      print('⚠️ [SEAT_BOOKED] Removing booked seat from local selection');
      final seats = List<String>.from(state.selectedSeats)..remove(seatNum);
      final ids = List<int>.from(state.selectedSeatIds);
      if (event.seatId != null) ids.remove(event.seatId);
      updateState((s) => s.copyWith(selectedSeats: seats, selectedSeatIds: ids));
    }
  }

  void _handleSeatReleased(SeatAvailabilityEvent event) {
    final seatNum = event.seatNumber;
    if (seatNum == null) return;
    
    print('🎯 [SEAT_RELEASED] Seat: $seatNum, EventUserId: ${event.userId}');
    _applyRealtimeStatus(seatNum, 'AVAILABLE', event.seatId, null);
  }

  void _handleSeatExpired(SeatAvailabilityEvent event) {
    final seatNum = event.seatNumber;
    if (seatNum == null) return;
    _applyRealtimeStatus(seatNum, 'AVAILABLE', event.seatId, null);

    final isOwnSeat = event.userId == _currentUserId ||
        state.selectedSeats.contains(seatNum);
    if (isOwnSeat) {
      final seats = List<String>.from(state.selectedSeats)..remove(seatNum);
      final ids = List<int>.from(state.selectedSeatIds);
      if (event.seatId != null) ids.remove(event.seatId);
      updateState((s) => s.copyWith(selectedSeats: seats, selectedSeatIds: ids));

      Get.snackbar(
        'Seat Expired',
        'Seat $seatNum selection has expired.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void _handleStateSyncResponse(SeatAvailabilityEvent event) {
    if (event.seats == null) return;
    
    print('🔄 [STATE_SYNC] Received ${event.seats!.length} seats from server');
    final updated = Map<String, SeatInfo>.from(state.realtimeSeats);
    
    for (final raw in event.seats!) {
      if (raw is! Map) continue;
      final seatNum = raw['seatNumber'] as String?;
      if (seatNum == null) continue;
      
      final userId = raw['userId']?.toString();
      final status = raw['status'] as String? ?? 'AVAILABLE';
      
      print('🔄 [STATE_SYNC] Seat $seatNum: $status ${userId != null ? "(user: $userId)" : ""}');
      
      updated[seatNum] = SeatInfo(
        seatId: raw['seatId'] as int?,
        seatNumber: seatNum,
        status: status,
        selectedByUserId: userId,
        lastUpdated: DateTime.now(),
      );
    }
    
    print('🔄 [STATE_SYNC] Updated ${updated.length} seats in local state');
    updateState((s) => s.copyWith(realtimeSeats: updated));
  }

  void _applyRealtimeStatus(
      String seatNumber, String status, int? seatId, String? userId) {
    print('🔧 [APPLY] Seat: $seatNumber, Status: $status, UserId: $userId, SeatId: $seatId');
    final updated = Map<String, SeatInfo>.from(state.realtimeSeats);
    final existing = updated[seatNumber];
    updated[seatNumber] = SeatInfo(
      seatId: seatId ?? existing?.seatId,
      seatNumber: seatNumber,
      status: status,
      selectedByUserId: userId,
      lastUpdated: DateTime.now(),
    );
    print('🔧 [APPLY] Updated realtimeSeats map, total seats: ${updated.length}');
    updateState((s) => s.copyWith(realtimeSeats: updated));
    print('🔧 [APPLY] State updated successfully');
  }

  void _requestStateSync() {
    if (_disposed) {
      print('⚠️ [STATE_SYNC] Controller disposed, skipping sync request');
      return;
    }
    
    if (_wsService.currentStatus != ConnectionStatus.connected) {
      print('⚠️ [STATE_SYNC] Not connected, cannot request sync (status: ${_wsService.currentStatus})');
      return;
    }
    
    print('🔄 [STATE_SYNC] Requesting state sync for schedule ${state.scheduleId}');
    print('🔄 [STATE_SYNC] Destination: ${NetworkConstant.seatSyncDest(state.scheduleId)}');
    
    _wsService.sendToDestination(
      NetworkConstant.seatSyncDest(state.scheduleId),
      {'scheduleId': state.scheduleId},
    );
    
    print('✅ [STATE_SYNC] State sync request sent');
  }

  // MARK - Fetch Seat (static layout)

  Future<void> fetchBusSeat(int scheduleId) async {
    updateState((s) => s.copyWith(isLoading: true));

    final result = await _repository.fetchBusSeat(scheduleId);
    switch (result) {
      case Success<SeatLayoutModel?>():
        print('✅ [SelectSeat] Bus seat data loaded');
        final seats = result.data?.seat;
        // Preserve any realtime state already received (e.g. from a state-sync response
        // that arrived while the HTTP request was in flight).
        final previousRealtime = Map<String, SeatInfo>.from(state.realtimeSeats);
        final realtimeMap = <String, SeatInfo>{};
        if (seats != null) {
          for (final seat in seats) {
            if (seat.seatNumber == null) continue;
            final existing = previousRealtime[seat.seatNumber!];
            if (existing != null && !existing.isAvailable()) {
              // Keep PENDING / BOOKED realtime status; just refresh the seatId
              realtimeMap[seat.seatNumber!] = existing.copyWith(seatId: seat.id);
            } else {
              realtimeMap[seat.seatNumber!] = SeatInfo(
                seatId: seat.id,
                seatNumber: seat.seatNumber!,
                status: seat.status == SeatStatusEnum.unavailable.status
                    ? 'BOOKED'
                    : 'AVAILABLE',
              );
            }
          }
        }
        updateState((s) => s.copyWith(
              isLoading: false,
              model: result.data,
              realtimeSeats: realtimeMap,
            ));
        _requestStateSyncWhenReady();

      case Error<SeatLayoutModel?>():
        print('❌ [SelectSeat] Error loading bus seat: ${result.error.displayMessage}');
        updateState((s) => s.copyWith(isLoading: false));
    }
  }
  
  void _requestStateSyncWhenReady() {
    // If already connected, request immediately
    if (_wsService.currentStatus == ConnectionStatus.connected) {
      print('🔄 [SelectSeat] WebSocket already connected, requesting state sync now');
      _requestStateSync();
    } else {
      // Otherwise, wait for connection (will be triggered in _onStatusChanged)
      print('🔄 [SelectSeat] WebSocket not yet connected, will sync when connected');
    }
  }

  // MARK - Seat Selection

  void selectSeat(String seatNumber) {
    final info = state.realtimeSeats[seatNumber];
    final available = info?.isAvailable() ?? _isSeatAvailableFromModel(seatNumber);
    if (!available) return;

    final seatId = info?.seatId ?? _getSeatIdFromModel(seatNumber);
    final updated = Map<String, SeatInfo>.from(state.realtimeSeats);
    updated[seatNumber] = SeatInfo(
      seatId: seatId,
      seatNumber: seatNumber,
      status: 'PENDING',
      selectedByUserId: _currentUserId,
      lastUpdated: DateTime.now(),
    );

    updateState((s) => s.copyWith(
      realtimeSeats: updated,
      selectedSeats: [...s.selectedSeats, seatNumber],
      selectedSeatIds: seatId != null
          ? [...s.selectedSeatIds, seatId]
          : s.selectedSeatIds,
    ));

    final payload = {
      'scheduleId': state.scheduleId,
      if (seatId != null) 'seatId': seatId,
      'seatNumber': seatNumber,
      if (_currentUserId != null) 'userId': _currentUserId,
    };
    
    print('');
    print('═══════════════════════════════════════════════════════');
    print('📤 [SELECT] SENDING SEAT SELECTION');
    print('═══════════════════════════════════════════════════════');
    print('📤 [SELECT] Seat: $seatNumber');
    print('📤 [SELECT] Seat ID: $seatId');
    print('📤 [SELECT] User ID: $_currentUserId');
    print('📤 [SELECT] Schedule ID: ${state.scheduleId}');
    print('📤 [SELECT] Destination: ${NetworkConstant.seatSelectDest(state.scheduleId)}');
    print('📤 [SELECT] Full payload: $payload');
    print('📤 [SELECT] Connection status: ${state.connectionStatus}');
    print('═══════════════════════════════════════════════════════');
    print('');
    
    _wsService.sendToDestination(
      NetworkConstant.seatSelectDest(state.scheduleId),
      payload,
    );
  }

  void deselectSeat(String seatNumber) {
    final info = state.realtimeSeats[seatNumber];
    final ownedByMe = info != null
        ? info.isPending() && info.isSelectedBy(_currentUserId ?? '')
        : state.selectedSeats.contains(seatNumber);
    if (!ownedByMe) return;

    final seatId = info?.seatId ?? _getSeatIdFromModel(seatNumber);
    final updated = Map<String, SeatInfo>.from(state.realtimeSeats);
    updated[seatNumber] = SeatInfo(
      seatId: seatId,
      seatNumber: seatNumber,
      status: 'AVAILABLE',
      selectedByUserId: null,
      lastUpdated: DateTime.now(),
    );

    final seats = List<String>.from(state.selectedSeats)..remove(seatNumber);
    final ids = List<int>.from(state.selectedSeatIds);
    if (seatId != null) ids.remove(seatId);

    updateState((s) => s.copyWith(
      realtimeSeats: updated,
      selectedSeats: seats,
      selectedSeatIds: ids,
    ));

    _wsService.sendToDestination(
      NetworkConstant.seatDeselectDest(state.scheduleId),
      {
        'scheduleId': state.scheduleId,
        if (seatId != null) 'seatId': seatId,
        'seatNumber': seatNumber,
        if (_currentUserId != null) 'userId': _currentUserId,
      },
    );
  }

  void toggleSeat(String seatNumber) {
    final info = state.realtimeSeats[seatNumber];
    final isMyPending = info != null
        ? info.isPending() && info.isSelectedBy(_currentUserId ?? '')
        : state.selectedSeats.contains(seatNumber);

    if (isMyPending) {
      deselectSeat(seatNumber);
    } else {
      selectSeat(seatNumber);
    }
  }

  void retryConnection() {
    if (state.scheduleId != 0) {
      _wsService.retryNow();
    }
  }

  void manualStateSync() {
    print('🔄 [MANUAL] Requesting state sync for schedule ${state.scheduleId}');
    _requestStateSync();
    // Snackbar removed - causes issues in dialog context
  }

  // MARK - Helpers (legacy API compatibility)

  bool isSeatAvailable(String seatNumber) {
    final info = state.realtimeSeats[seatNumber];
    return info?.isAvailable() ?? _isSeatAvailableFromModel(seatNumber);
  }

  bool isSeatBooked(String seatNumber) {
    final info = state.realtimeSeats[seatNumber];
    return info?.isBooked() ?? !_isSeatAvailableFromModel(seatNumber);
  }

  bool isSeatSelected(String seatNumber) =>
      state.selectedSeats.contains(seatNumber);

  bool isSeatPendingByOther(String seatNumber) {
    final info = state.realtimeSeats[seatNumber];
    if (info == null || !info.isPending()) return false;
    return info.selectedByUserId != _currentUserId;
  }

  String? get currentUserId => _currentUserId;

  String getDebugToken() {
    return _localRepository.getToken() ?? '';
  }

  bool _isSeatAvailableFromModel(String seatNumber) {
    if (state.model?.seat == null || state.model!.seat!.isEmpty) return true;
    final seat = state.model?.seat?.firstWhere(
      (s) => s.seatNumber == seatNumber,
      orElse: () => Seat(),
    );
    return seat?.status == SeatStatusEnum.available.status || seat?.id == null;
  }

  int? _getSeatIdFromModel(String seatNumber) {
    return state.model?.seat
        ?.firstWhere((s) => s.seatNumber == seatNumber, orElse: () => Seat())
        .id;
  }
}
