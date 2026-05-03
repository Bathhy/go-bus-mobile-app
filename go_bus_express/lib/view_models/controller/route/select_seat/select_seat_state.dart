import 'package:go_bus_express/core/services/websocket_service.dart';
import 'package:go_bus_express/models/route/seat_layout_model.dart';

import '../../../../core/base/base_ui_state.dart';

class SeatInfo {
  final int? seatId;
  final String seatNumber;
  final String status;
  final String? selectedByUserId;
  final DateTime? lastUpdated;

  const SeatInfo({
    this.seatId,
    required this.seatNumber,
    required this.status,
    this.selectedByUserId,
    this.lastUpdated,
  });

  SeatInfo copyWith({
    int? seatId,
    String? seatNumber,
    String? status,
    String? selectedByUserId,
    bool clearOwner = false,
    DateTime? lastUpdated,
  }) {
    return SeatInfo(
      seatId: seatId ?? this.seatId,
      seatNumber: seatNumber ?? this.seatNumber,
      status: status ?? this.status,
      selectedByUserId: clearOwner ? null : (selectedByUserId ?? this.selectedByUserId),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool isAvailable() => status == 'AVAILABLE';
  bool isPending() => status == 'PENDING';
  bool isBooked() => status == 'BOOKED';
  bool isSelectedBy(String userId) => selectedByUserId == userId;
}

class SelectSeatState extends BaseUiState {
  final SeatLayoutModel? model;
  final List<String> selectedSeats;
  final List<int> selectedSeatIds;
  final String origin;
  final String destination;
  final String? departureDate;
  final String departureTime;
  final double unitPrice;
  final int scheduleId;
  final ConnectionStatus connectionStatus;
  final String? wsErrorMessage;
  final Map<String, SeatInfo> realtimeSeats;

  SelectSeatState({
    super.isLoading = false,
    this.model = const SeatLayoutModel(),
    this.selectedSeats = const [],
    this.selectedSeatIds = const [],
    this.origin = '',
    this.destination = '',
    this.departureDate,
    this.departureTime = '',
    this.unitPrice = 0.0,
    this.scheduleId = 0,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.wsErrorMessage,
    this.realtimeSeats = const {},
  });

  SelectSeatState copyWith({
    bool? isLoading,
    SeatLayoutModel? model,
    List<String>? selectedSeats,
    List<int>? selectedSeatIds,
    String? origin,
    String? destination,
    String? departureDate,
    String? departureTime,
    double? unitPrice,
    int? scheduleId,
    ConnectionStatus? connectionStatus,
    String? wsErrorMessage,
    bool clearWsError = false,
    Map<String, SeatInfo>? realtimeSeats,
  }) {
    return SelectSeatState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      selectedSeatIds: selectedSeatIds ?? this.selectedSeatIds,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      unitPrice: unitPrice ?? this.unitPrice,
      scheduleId: scheduleId ?? this.scheduleId,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      wsErrorMessage: clearWsError ? null : (wsErrorMessage ?? this.wsErrorMessage),
      realtimeSeats: realtimeSeats ?? this.realtimeSeats,
    );
  }

  SeatInfo? getSeat(String seatNumber) => realtimeSeats[seatNumber];

  bool isSeatAvailableRealtime(String seatNumber) {
    final info = realtimeSeats[seatNumber];
    return info == null || info.isAvailable();
  }

  bool isSeatSelectedByCurrentUser(String seatNumber, String currentUserId) {
    final info = realtimeSeats[seatNumber];
    if (info == null) return selectedSeats.contains(seatNumber);
    return info.isPending() && info.isSelectedBy(currentUserId);
  }

  List<String> getAvailableSeats() => realtimeSeats.entries
      .where((e) => e.value.isAvailable())
      .map((e) => e.key)
      .toList();
}
