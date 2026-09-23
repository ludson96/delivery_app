class OrderItemPayload {
  final int productId;
  final int quantity;

  const OrderItemPayload({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

class CreateOrderPayload {
  final double totalPrice;
  final String deliveryAddress;
  final String deliveryNumber;
  final int sellerId;
  final List<OrderItemPayload> products;

  const CreateOrderPayload({
    required this.totalPrice,
    required this.deliveryAddress,
    required this.deliveryNumber,
    this.sellerId = 2, // ID padrão do vendedor conforme o app web original
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalPrice': totalPrice,
      'deliveryAddress': deliveryAddress,
      'deliveryNumber': deliveryNumber,
      'sellerId': sellerId,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
