import 'package:shared_preferences/shared_preferences.dart';

class SpService {

  Future<void> setToken(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('x-auth-token');
  }
}