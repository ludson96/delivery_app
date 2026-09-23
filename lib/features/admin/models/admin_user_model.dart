class AdminUserModel {
  final int id;
  final String name;
  final String email;
  final String role;

  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'customer',
    );
  }
}
