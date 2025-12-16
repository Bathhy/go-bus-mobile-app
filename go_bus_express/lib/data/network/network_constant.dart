import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkConstant {
  static String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';
  static String bakongToken = dotenv.env['BAKONG_TOKEN'] ?? '168';
}
