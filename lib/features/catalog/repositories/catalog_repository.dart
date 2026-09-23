import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/product_model.dart';

class CatalogRepository {
  final ApiClient _apiClient;

  CatalogRepository(this._apiClient);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiClient.dio.get('/products');
      final list = response.data as List;
      return list.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Não foi possível carregar as bebidas.';
      throw Exception(message);
    } catch (e) {
      throw Exception('Erro ao carregar catálogo: $e');
    }
  }
}
