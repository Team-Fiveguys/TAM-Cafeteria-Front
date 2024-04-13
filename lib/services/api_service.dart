import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://dev.tam-cafeteria.site/";
  static Future<void> test() async {
    final url = Uri.http('dev.tam-cafeteria.site', '/cafeteria', {
      'name': "명진당",
      'address': "123",
      'hour': "11:30 ~ 14:30",
    });
    final response = await http.post(url);
    if (response.statusCode == 200) {}
  }
}
