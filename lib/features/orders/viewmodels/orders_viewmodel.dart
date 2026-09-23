import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/order_model.dart';
import '../repositories/orders_repository.dart';
import '../services/socket_service.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrdersRepository(apiClient);
});

final socketServiceProvider = Provider<SocketService>((ref) {
  final socketService = SocketService();
  socketService.connect();
  ref.onDispose(() {
    socketService.disconnect();
  });
  return socketService;
});

class OrdersViewModel extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final OrdersRepository _repository;
  final SocketService _socketService;

  OrdersViewModel(this._repository, this._socketService) : super(const AsyncValue.loading()) {
    loadOrders();
    _setupSocketListener();
  }

  Future<void> loadOrders() async {
    try {
      final orders = await _repository.getOrders();
      state = AsyncValue.data(orders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _setupSocketListener() {
    _socketService.addListener((saleId, status) {
      state.whenData((orders) {
        final updatedList = orders.map((order) {
          if (order.id == saleId) {
            return order.copyWith(status: status);
          }
          return order;
        }).toList();
        state = AsyncValue.data(updatedList);
      });
    });
  }

  Future<void> updateStatus(int orderId, String newStatus) async {
    try {
      await _repository.updateOrderStatus(orderId: orderId, status: newStatus);
      // Atualizar localmente de imediato
      state.whenData((orders) {
        final updatedList = orders.map((order) {
          if (order.id == orderId) {
            return order.copyWith(status: newStatus);
          }
          return order;
        }).toList();
        state = AsyncValue.data(updatedList);
      });
    } catch (e) {
      // Falha tratada
    }
  }
}

final ordersViewModelProvider = StateNotifierProvider.autoDispose<OrdersViewModel, AsyncValue<List<OrderModel>>>((ref) {
  final repository = ref.watch(ordersRepositoryProvider);
  final socketService = ref.watch(socketServiceProvider);
  return OrdersViewModel(repository, socketService);
});

// Provider para detalhe individual de pedido
final orderDetailProvider = FutureProvider.autoDispose.family<OrderModel?, int>((ref, orderId) async {
  final repository = ref.watch(ordersRepositoryProvider);
  return repository.getOrderById(orderId);
});
