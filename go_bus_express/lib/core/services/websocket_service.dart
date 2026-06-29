import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:stomp_dart_client/stomp_dart_client.dart';

enum ConnectionStatus { disconnected, connecting, connected, error }

/// STOMP-over-WebSocket service that mirrors the admin-side JS implementation.
///
/// The backend uses Spring Boot + STOMP + SockJS.
/// Flutter connects to the raw WebSocket transport endpoint directly
/// (SockJS `/websocket` sub-path) with the JWT token as a query parameter.
class WebSocketService {
  static const int _maxRetries = 5;
  static const Duration _maxDelay = Duration(seconds: 30);

  StompClient? _client;
  StompUnsubscribe? _topicUnsubscribe;

  final _messageController = StreamController<String>.broadcast();
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  Stream<String> get messages => _messageController.stream;
  Stream<ConnectionStatus> get connectionStatus => _statusController.stream;

  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;
  bool _disposed = false;
  int _retryCount = 0;
  Timer? _retryTimer;

  // Stored so reconnects can re-subscribe
  String? _baseUrl;
  String? _token;
  String? _subscribeTopic;

  /// Connect to the STOMP endpoint.
  ///
  /// [baseUrl]        — http(s) base URL of the SockJS endpoint,
  ///                    e.g. `http://192.168.1.8:8080/bus-service/ws/bus`
  /// [token]          — JWT access token (appended as `?token=…`)
  /// [scheduleId]     — Bus schedule ID to subscribe to
  /// [subscribeTopic] — STOMP topic to subscribe (see NetworkConstant.seatTopic)
  void connect({
    required String baseUrl,
    required String token,
    required int scheduleId,
    required String subscribeTopic,
  }) {
    if (_disposed) return;
    _baseUrl = baseUrl;
    _token = token;
    _subscribeTopic = subscribeTopic;
    _retryCount = 0;
    _activate();
  }

  void _activate() {
    if (_disposed) return;
    _updateStatus(ConnectionStatus.connecting);

    final wsUrl = _buildWsUrl(_baseUrl!, _token!);
    print('[STOMP] Connecting to: ${wsUrl.replaceAll(_token!, '***')}');

    _client = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: _onStompConnect,
        onStompError: (frame) {
          print('[STOMP] Error: ${frame.body}');
          _updateStatus(ConnectionStatus.error);
          _scheduleReconnect();
        },
        onWebSocketError: (error) {
          print('[STOMP] WS error: $error');
          _updateStatus(ConnectionStatus.error);
          _scheduleReconnect();
        },
        onDisconnect: (frame) {
          print('[STOMP] Disconnected');
          if (!_disposed) {
            _updateStatus(ConnectionStatus.disconnected);
            _scheduleReconnect();
          }
        },
        onWebSocketDone: () {
          print('[STOMP] WS closed');
          if (!_disposed) {
            _updateStatus(ConnectionStatus.disconnected);
            _scheduleReconnect();
          }
        },
        // Disable auto-reconnect — we handle it ourselves with backoff
        reconnectDelay: Duration.zero,
        heartbeatIncoming: const Duration(seconds: 4),
        heartbeatOutgoing: const Duration(seconds: 4),
      ),
    );
    _client!.activate();
  }

  void _onStompConnect(StompFrame frame) {
    print('[STOMP] Connected successfully!');
    print('[STOMP] Frame headers: ${frame.headers}');
    _retryCount = 0;
    _updateStatus(ConnectionStatus.connected);

    print('[STOMP] Subscribing to: $_subscribeTopic');
    _topicUnsubscribe = _client!.subscribe(
      destination: _subscribeTopic!,
      callback: (frame) {
        final body = frame.body;
        print('[STOMP] Message received on topic $_subscribeTopic');
        print('[STOMP] Frame headers: ${frame.headers}');
        if (body != null && !_messageController.isClosed) {
          print('[STOMP] Body (${body.length} chars): $body');
          _messageController.add(body);
        } else {
          print('[STOMP] Body is null or controller closed');
        }
      },
    );
    print('[STOMP] Successfully subscribed to: $_subscribeTopic');
  }

  /// Send a message to a STOMP destination.
  ///
  /// [destination] — e.g. `/app/schedule/1/seat/select`
  /// [body]        — map that will be JSON-encoded
  void sendToDestination(String destination, Map<String, dynamic> body) {
    if (_currentStatus != ConnectionStatus.connected || _client == null) {
      print('[STOMP] Cannot send, not connected (queuing not supported for STOMP)');
      return;
    }
    try {
      final encoded = jsonEncode(body);
      _client!.send(destination: destination, body: encoded);
      print('[STOMP] Sent to $destination');
    } catch (e) {
      print('[STOMP] Send failed: $e');
    }
  }

  void _scheduleReconnect() {
    if (_disposed || _retryCount >= _maxRetries) {
      if (_retryCount >= _maxRetries) {
        print('[STOMP] Max retries ($_maxRetries) reached');
        _updateStatus(ConnectionStatus.error);
      }
      return;
    }

    final delay = _backoffDelay(_retryCount);
    _retryCount++;
    print('[STOMP] Retry $_retryCount/$_maxRetries in ${delay.inSeconds}s');

    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () {
      if (!_disposed) _activate();
    });
  }

  Duration _backoffDelay(int attempt) {
    final seconds = 1 * (1 << attempt); // 1, 2, 4, 8, 16
    return Duration(seconds: seconds.clamp(0, _maxDelay.inSeconds));
  }

  /// Converts the SockJS http base URL to the raw WS transport URL.
  ///
  /// Spring Boot SockJS exposes the WebSocket transport at `{base}/websocket`.
  String _buildWsUrl(String baseUrl, String token) {
    final ws = baseUrl
        .replaceFirst(RegExp(r'^http://'), 'ws://')
        .replaceFirst(RegExp(r'^https://'), 'wss://');
    // Append the SockJS websocket transport path
    final withPath = ws.endsWith('/websocket') ? ws : '$ws/websocket';
    return '$withPath?token=${Uri.encodeComponent(token)}';
  }

  void _updateStatus(ConnectionStatus status) {
    _currentStatus = status;
    if (!_statusController.isClosed) _statusController.add(status);
  }

  ConnectionStatus get currentStatus => _currentStatus;

  void retryNow() {
    _retryTimer?.cancel();
    _retryCount = 0;
    _activate();
  }

  Future<void> dispose() async {
    _disposed = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    _topicUnsubscribe?.call();
    _topicUnsubscribe = null;
    _client?.deactivate();
    _client = null;
    if (!_messageController.isClosed) await _messageController.close();
    if (!_statusController.isClosed) await _statusController.close();
  }
}
