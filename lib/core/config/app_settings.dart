import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const _keyApiKey = 'wisphub_api_key';
  static const _keyBaseUrl = 'wisphub_base_url';

  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyApiKey);
  }

  static Future<String?> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBaseUrl);
  }

  static Future<void> save({
    required String apiKey,
    required String baseUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyApiKey, apiKey.trim());
    String url = baseUrl.trim();
    if (!url.endsWith('/')) url += '/';
    await prefs.setString(_keyBaseUrl, url);
  }

  static Future<bool> isConfigured() async {
    final key = await getApiKey();
    final url = await getBaseUrl();
    return key != null && key.isNotEmpty && url != null && url.isNotEmpty;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyApiKey);
    await prefs.remove(_keyBaseUrl);
  }
}
