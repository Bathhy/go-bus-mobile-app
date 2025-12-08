import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConstant {
  static String baseurl = "http://$_ipAdd:3000/api/v1/uni";
  static final String _ipAdd = dotenv.env['IP_ADDRESS']!;
}
