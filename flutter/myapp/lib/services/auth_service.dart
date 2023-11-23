import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, String>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://6cd0-2a01-e0a-2bd-f2b0-bc50-b541-ebdc-f798.ngrok-free.app/api/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'username': data['username']
      };
    } else {
      throw Exception('Failed to login');
    }
  }
}

