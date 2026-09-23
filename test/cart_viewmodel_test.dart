import 'package:flutter_test/flutter_test.dart';
import 'package:delivery_app/features/catalog/models/product_model.dart';
import 'package:delivery_app/features/cart/viewmodels/cart_viewmodel.dart';

void main() {
  group('CartViewModel Tests', () {
    late CartViewModel cartViewModel;

    const testProduct1 = ProductModel(
      id: 1,
      name: 'Skol Lata 350ml',
      price: 2.50,
      urlImage: 'http://example.com/skol.jpg',
    );

    const testProduct2 = ProductModel(
      id: 2,
      name: 'Heineken 600ml',
      price: 7.50,
      urlImage: 'http://example.com/heineken.jpg',
    );

    setUp(() {
      cartViewModel = CartViewModel();
    });

    test('Deve iniciar com o carrinho vazio', () {
      expect(cartViewModel.state.isEmpty, isTrue);
      expect(cartViewModel.state.totalItemCount, 0);
      expect(cartViewModel.state.totalPrice, 0.0);
    });

    test('Deve adicionar e incrementar item no carrinho', () {
      cartViewModel.increment(testProduct1);

      expect(cartViewModel.state.isEmpty, isFalse);
      expect(cartViewModel.state.totalItemCount, 1);
      expect(cartViewModel.state.getQuantity(1), 1);
      expect(cartViewModel.state.totalPrice, 2.50);

      cartViewModel.increment(testProduct1);
      expect(cartViewModel.state.totalItemCount, 2);
      expect(cartViewModel.state.getQuantity(1), 2);
      expect(cartViewModel.state.totalPrice, 5.00);
    });

    test('Deve decrementar e remover item quando quantidade for zero', () {
      cartViewModel.setQuantity(testProduct1, 2);
      expect(cartViewModel.state.totalItemCount, 2);

      cartViewModel.decrement(testProduct1);
      expect(cartViewModel.state.totalItemCount, 1);
      expect(cartViewModel.state.totalPrice, 2.50);

      cartViewModel.decrement(testProduct1);
      expect(cartViewModel.state.isEmpty, isTrue);
      expect(cartViewModel.state.totalPrice, 0.0);
    });

    test('Deve calcular corretamente o total com múltiplos produtos distintos', () {
      cartViewModel.setQuantity(testProduct1, 2); // 2 * 2.50 = 5.00
      cartViewModel.setQuantity(testProduct2, 3); // 3 * 7.50 = 22.50

      expect(cartViewModel.state.totalItemCount, 5);
      expect(cartViewModel.state.totalPrice, 27.50);

      cartViewModel.removeItem(testProduct1.id);
      expect(cartViewModel.state.totalItemCount, 3);
      expect(cartViewModel.state.totalPrice, 22.50);

      cartViewModel.clearCart();
      expect(cartViewModel.state.isEmpty, isTrue);
      expect(cartViewModel.state.totalPrice, 0.0);
    });
  });
}
