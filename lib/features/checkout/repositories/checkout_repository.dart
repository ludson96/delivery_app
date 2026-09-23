import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/order_payload_model.dart';

class CheckoutRepository {
  final ApiClient _apiClient;

  CheckoutRepository(this._apiClient);

  Future<int> createOrder(CreateOrderPayload payload) async {
    try {
      final response = await _apiClient.dio.post(
        '/sales',
        data: payload.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['id'] != null) {
        return data['id'] as int;
      }
      return 0;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Erro ao finalizar o pedido.';
      throw Exception(message);
    } catch (e) {
      throw Exception('Falha ao processar checkout: $e');
    }
  }
}
