import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkConstant {
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  static String baseUrlBakong = dotenv.env['BASE_URL_BAKONG'] ?? 'http://localhost';

  // STOMP WebSocket — SockJS endpoint base URL (http/https scheme)
  // The service appends /websocket to reach the raw WS transport
  static String wsBaseUrl =
      dotenv.env['WS_BASE_URL'] ?? 'http://192.168.1.8:8080/bus-service/ws/bus';

  // STOMP topics & destinations (Spring Boot conventions)
  static String seatTopic(int scheduleId) =>
      dotenv.env['WS_SEAT_TOPIC']?.replaceAll('{scheduleId}', '$scheduleId') ??
      '/topic/schedule/$scheduleId/seats';

  static String seatSelectDest(int scheduleId) =>
      dotenv.env['WS_SEAT_SELECT_DEST']?.replaceAll('{scheduleId}', '$scheduleId') ??
      '/app/seat/select';

  static String seatDeselectDest(int scheduleId) =>
      dotenv.env['WS_SEAT_DESELECT_DEST']?.replaceAll('{scheduleId}', '$scheduleId') ??
      '/app/seat/deselect';

  static String seatSyncDest(int scheduleId) =>
      dotenv.env['WS_SEAT_SYNC_DEST']?.replaceAll('{scheduleId}', '$scheduleId') ??
      '/app/schedule/$scheduleId/seat/sync';
}
