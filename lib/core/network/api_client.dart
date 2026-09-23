import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../storage/local_storage_service.dart';

class ApiClient {
  final Dio dio;
  final LocalStorageService storageService;

  ApiClient({required this.storageService})
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storageService.getToken();
          if (token != null && token.isNotEmpty) {
            // No backend do Docker Drinks, o token pode ser enviado diretamente ou com Bearer
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Tratar 401 ou erros de conexão centralizados se necessário
          return handler.next(error);
        },
      ),
    );
  }
}
