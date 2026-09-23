import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../catalog/models/product_model.dart';
import '../models/cart_item_model.dart';

class CartState {
  final Map<int, CartItemModel> items;

  const CartState({this.items = const {}});

  List<CartItemModel> get itemList => items.values.toList();

  int get totalItemCount => items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  int getQuantity(int productId) => items[productId]?.quantity ?? 0;

  bool get isEmpty => items.isEmpty;

  CartState copyWith({Map<int, CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(const CartState());

  void setQuantity(ProductModel product, int quantity) {
    final updated = Map<int, CartItemModel>.from(state.items);

    if (quantity <= 0) {
      updated.remove(product.id);
    } else {
      updated[product.id] = CartItemModel(product: product, quantity: quantity);
    }

    state = state.copyWith(items: updated);
  }

  void increment(ProductModel product) {
    final currentQty = state.getQuantity(product.id);
    setQuantity(product, currentQty + 1);
  }

  void decrement(ProductModel product) {
    final currentQty = state.getQuantity(product.id);
    if (currentQty > 0) {
      setQuantity(product, currentQty - 1);
    }
  }

  void removeItem(int productId) {
    final updated = Map<int, CartItemModel>.from(state.items);
    updated.remove(productId);
    state = state.copyWith(items: updated);
  }

  void clearCart() {
    state = const CartState();
  }
}

final cartViewModelProvider = StateNotifierProvider<CartViewModel, CartState>((ref) {
  return CartViewModel();
});
