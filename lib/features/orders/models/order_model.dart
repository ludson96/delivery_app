class OrderProductItem {
  final int quantity;
  final int id;
  final String name;
  final double price;
  final String urlImage;

  const OrderProductItem({
    required this.quantity,
    required this.id,
    required this.name,
    required this.price,
    required this.urlImage,
  });

  factory OrderProductItem.fromJson(Map<String, dynamic> json) {
    final prod = json['product'] is Map<String, dynamic> ? json['product'] : json;
    return OrderProductItem(
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      id: prod['id'] is int ? prod['id'] : int.tryParse(prod['id']?.toString() ?? '0') ?? 0,
      name: prod['name'] ?? '',
      price: prod['price'] != null ? double.tryParse(prod['price'].toString()) ?? 0.0 : 0.0,
      urlImage: prod['url_image'] ?? prod['urlImage'] ?? '',
    );
  }
}

class OrderModel {
  final int id;
  final int sellerId;
  final String status;
  final String saleDate;
  final double totalPrice;
  final String deliveryAddress;
  final String deliveryNumber;
  final List<OrderProductItem> products;

  const OrderModel({
    required this.id,
    required this.sellerId,
    required this.status,
    required this.saleDate,
    required this.totalPrice,
    this.deliveryAddress = '',
    this.deliveryNumber = '',
    this.products = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var rawProducts = json['products'];
    List<OrderProductItem> parsedProducts = [];
    if (rawProducts is List) {
      parsedProducts = rawProducts.map((p) => OrderProductItem.fromJson(p as Map<String, dynamic>)).toList();
    }

    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      sellerId: json['sellerId'] is int ? json['sellerId'] : int.tryParse(json['sellerId']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? 'Pendente',
      saleDate: json['saleDate'] ?? '',
      totalPrice: json['totalPrice'] != null ? double.tryParse(json['totalPrice'].toString()) ?? 0.0 : 0.0,
      deliveryAddress: json['deliveryAddress'] ?? '',
      deliveryNumber: json['deliveryNumber'] ?? '',
      products: parsedProducts,
    );
  }

  OrderModel copyWith({
    int? id,
    int? sellerId,
    String? status,
    String? saleDate,
    double? totalPrice,
    String? deliveryAddress,
    String? deliveryNumber,
    List<OrderProductItem>? products,
  }) {
    return OrderModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      status: status ?? this.status,
      saleDate: saleDate ?? this.saleDate,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryNumber: deliveryNumber ?? this.deliveryNumber,
      products: products ?? this.products,
    );
  }
}
