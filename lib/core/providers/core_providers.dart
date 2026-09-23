import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../storage/local_storage_service.dart';

// Provedor para SharedPreferences (inicializado no main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences deve ser inicializado no main');
});

// Provedor para o LocalStorageService
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

// Provedor para o ApiClient (Dio)
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return ApiClient(storageService: storage);
});
