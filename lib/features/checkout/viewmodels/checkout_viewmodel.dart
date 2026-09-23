import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../cart/viewmodels/cart_viewmodel.dart';
import '../models/order_payload_model.dart';
import '../repositories/checkout_repository.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CheckoutRepository(apiClient);
});

class CheckoutState {
  final bool isLoading;
  final String? errorMessage;
  final int? createdOrderId;

  const CheckoutState({
    this.isLoading = false,
    this.errorMessage,
    this.createdOrderId,
  });

  CheckoutState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? createdOrderId,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      createdOrderId: createdOrderId ?? this.createdOrderId,
    );
  }
}

class CheckoutViewModel extends StateNotifier<CheckoutState> {
  final CheckoutRepository _repository;
  final Ref _ref;

  CheckoutViewModel(this._repository, this._ref) : super(const CheckoutState());

  Future<int?> submitOrder({
    required String address,
    required String number,
  }) async {
    final cartState = _ref.read(cartViewModelProvider);

    if (cartState.isEmpty) {
      state = state.copyWith(errorMessage: 'Seu carrinho está vazio.');
      return null;
    }

    if (address.trim().isEmpty || number.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Preencha o endereço e número da entrega.');
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final payload = CreateOrderPayload(
        totalPrice: cartState.totalPrice,
        deliveryAddress: address.trim(),
        deliveryNumber: number.trim(),
        products: cartState.itemList
            .map((item) => OrderItemPayload(
                  productId: item.product.id,
                  quantity: item.quantity,
                ))
            .toList(),
      );

      final orderId = await _repository.createOrder(payload);

      // Limpar o carrinho após sucesso
      _ref.read(cartViewModelProvider.notifier).clearCart();

      state = state.copyWith(isLoading: false, createdOrderId: orderId);
      return orderId;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }
}

final checkoutViewModelProvider = StateNotifierProvider<CheckoutViewModel, CheckoutState>((ref) {
  final repository = ref.watch(checkoutRepositoryProvider);
  return CheckoutViewModel(repository, ref);
});
