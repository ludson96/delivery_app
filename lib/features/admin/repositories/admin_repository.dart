import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/admin_user_model.dart';

class AdminRepository {
  final ApiClient _apiClient;

  AdminRepository(this._apiClient);

  Future<List<AdminUserModel>> getUsers() async {
    try {
      final response = await _apiClient.dio.get('/admin/manager');
      final list = response.data as List;
      return list.map((item) => AdminUserModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Erro ao buscar usuários do sistema.';
      throw Exception(message);
    } catch (e) {
      throw Exception('Falha no painel administrativo: $e');
    }
  }
}
