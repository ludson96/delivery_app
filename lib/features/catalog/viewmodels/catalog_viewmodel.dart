import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/product_model.dart';
import '../repositories/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRepository(apiClient);
});

// FutureProvider para carregar os produtos de forma reativa com refresh
final catalogProductsProvider = FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getProducts();
});
