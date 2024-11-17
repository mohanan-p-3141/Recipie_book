import 'package:recepies_app/services/http_service.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  final _httpService = HTTPService();

  User? user;

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

 Future<bool> login(String username, String password) async {
  try {
    if (username.isEmpty || password.isEmpty) {
      print("Error: Username or password is empty.");
      return false;
    }

    final response = await _httpService.post("auth/login", {
      "username": username,
      "password": password,
    });

    if (response == null) {
      print("Error: No response from the server.");
      return false;
    }

    // Log the raw response to see its structure
    print("Response: ${response.data}");
    print("Status Code: ${response.statusCode}");

    if (response.statusCode == 200 && response.data != null) {
      try {
        user = User.fromJson(response.data);

        if (user?.token == null || user!.token.isEmpty) {
          print("Error: Missing or invalid token in response.");
          return false;
        }

        _httpService.setup(bearerToken: user!.token);
        return true;
      } catch (e) {
        print("Error parsing user data: $e");
        return false;
      }
    } else {
      print("Login failed. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Login error: $e");
  }
  return false;
}
}