import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:frontend/core/constant/constant.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/features/auth/repository/auth_local_repo.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class RemoteAuthRepo {
  final _spService = SpService();
  final AuthLocalRepo _authLocalRepo = AuthLocalRepo();
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUrl}/auth/signup',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 201) {
        throw (jsonDecode(res.body))["error"];
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUrl}/auth/login',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 200) {
        throw (jsonDecode(res.body))["error"];
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }
  Future<UserModel?> getUserData(

  ) async {
    final token = await _spService.getToken();
    if (token == null || token.isEmpty) {
      return null;
    }
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.backendUrl}/auth/tokenIsValid',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        
      );

      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }

      http.Response res2 = await http.get(
        Uri.parse(
          '${Constants.backendUrl}/auth',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      if (res2.statusCode != 200) {
        return jsonDecode( res2.body)["error"];
      }

      return UserModel.fromJson(res2.body);
    } catch (e) {
      final user = await _authLocalRepo.getUser();

        return user;
      
    }
  }
}
