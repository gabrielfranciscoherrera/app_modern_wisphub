import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiKey => dotenv.env['STAFF_API_KEY'] ?? '';
  static String get baseUrl =>
      dotenv.env['WISPHUB_BASE_URL'] ?? 'https://api.wisphub.net/api/';
}
