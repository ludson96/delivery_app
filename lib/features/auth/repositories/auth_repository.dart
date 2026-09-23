import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<UserModel> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final userData = data['user'] as Map<String, dynamic>;

      return UserModel.fromJson(userData, token: token);
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Falha ao realizar login. Verifique suas credenciais.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final userData = data['user'] as Map<String, dynamic>;

      return UserModel.fromJson(userData, token: token);
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ?? 'Falha ao realizar cadastro.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }
}
