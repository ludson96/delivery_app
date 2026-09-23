import 'package:dio/dio.dart';

class CepAddress {
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  const CepAddress({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  String get fullStreet => logradouro.isNotEmpty ? '$logradouro, $bairro - $localidade/$uf' : '$localidade/$uf';

  factory CepAddress.fromJson(Map<String, dynamic> json) {
    return CepAddress(
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}

class CepService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
    ),
  );

  static Future<CepAddress?> fetchAddressByCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
    if (cleanCep.length != 8) return null;

    try {
      final response = await _dio.get('https://viacep.com.br/ws/$cleanCep/json/');
      if (response.statusCode == 200 && response.data is Map) {
        if (response.data['erro'] == true) return null;
        return CepAddress.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
