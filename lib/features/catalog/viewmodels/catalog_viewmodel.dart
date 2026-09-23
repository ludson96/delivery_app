import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/product_model.dart';
import '../repositories/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRepository(apiClient);
});

// FutureProvider para carregar os produtos brutos da API
final catalogProductsProvider = FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getProducts();
});

// Provider para o termo de pesquisa digitado pelo usuário
final catalogSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

// Provider para filtro de categoria selecionada ('Todas', 'Latas', 'Long Necks', 'Garrafas')
final catalogCategoryFilterProvider = StateProvider.autoDispose<String>((ref) => 'Todas');

// Provider filtrado reativamente combinando busca por texto e categoria
final filteredCatalogProductsProvider = Provider.autoDispose<AsyncValue<List<ProductModel>>>((ref) {
  final productsAsync = ref.watch(catalogProductsProvider);
  final searchQuery = ref.watch(catalogSearchQueryProvider).trim().toLowerCase();
  final selectedCategory = ref.watch(catalogCategoryFilterProvider);

  return productsAsync.whenData((products) {
    return products.where((product) {
      final nameMatches = product.name.toLowerCase().contains(searchQuery);

      bool categoryMatches = true;
      if (selectedCategory == 'Latas') {
        categoryMatches = product.name.toLowerCase().contains('lata') || product.name.toLowerCase().contains('269ml') || product.name.toLowerCase().contains('350ml');
      } else if (selectedCategory == 'Long Necks') {
        categoryMatches = product.name.toLowerCase().contains('330ml') || product.name.toLowerCase().contains('313ml') || product.name.toLowerCase().contains('275ml');
      } else if (selectedCategory == 'Garrafas') {
        categoryMatches = product.name.toLowerCase().contains('600ml') || product.name.toLowerCase().contains('1l');
      }

      return nameMatches && categoryMatches;
    }).toList();
  });
});
