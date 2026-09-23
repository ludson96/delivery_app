import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/admin_user_model.dart';
import '../repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminRepository(apiClient);
});

final adminUsersProvider = FutureProvider.autoDispose<List<AdminUserModel>>((ref) async {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.getUsers();
});
