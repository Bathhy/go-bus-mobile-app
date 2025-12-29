import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String basePhNumber =
      dotenv.env['PHONE_NUMBER_SUPPORT'] ?? '0000000000';
  static String baseTelegramUrl =
      dotenv.env['TELEGRAM_CHANNEL_URL'] ?? 'https://t.me';
}
