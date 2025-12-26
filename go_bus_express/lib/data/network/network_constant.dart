import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkConstant {
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  static String baseUrlBakong = dotenv.env['BASE_URL_BAKONG'] ?? 'http://localhost';
}
