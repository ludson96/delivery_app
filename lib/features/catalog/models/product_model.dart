class ProductModel {
  final int id;
  final String name;
  final double price;
  final String urlImage;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.urlImage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      urlImage: json['url_image'] ?? json['urlImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'urlImage': urlImage,
    };
  }
}
