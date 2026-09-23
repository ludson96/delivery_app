import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/order_model.dart';

class OrdersRepository {
  final ApiClient _apiClient;

  OrdersRepository(this._apiClient);

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiClient.dio.get('/sales');
      final list = response.data as List;
      return list.map((item) => OrderModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Erro ao carregar lista de pedidos.';
      throw Exception(message);
    } catch (e) {
      throw Exception('Falha ao buscar pedidos: $e');
    }
  }

  Future<OrderModel?> getOrderById(int orderId) async {
    try {
      // Como o endpoint /sales lista todos do usuário, podemos consultar e filtrar, ou bater em /sales/:id
      final response = await _apiClient.dio.get('/sales');
      final list = response.data as List;
      final found = list.firstWhere(
        (item) => item['id'] == orderId,
        orElse: () => null,
      );
      if (found != null) {
        return OrderModel.fromJson(found as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Erro ao carregar detalhes do pedido.';
      throw Exception(message);
    } catch (e) {
      throw Exception('Falha ao buscar detalhes do pedido: $e');
    }
  }

  Future<void> updateOrderStatus({required int orderId, required String status}) async {
    try {
      await _apiClient.dio.patch(
        '/sales/$orderId/status',
        data: {'status': status},
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Erro ao atualizar status.';
      throw Exception(message);
    }
  }
}
