import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/app_constants.dart';

typedef StatusUpdateCallback = void Function(int saleId, String status);

class SocketService {
  io.Socket? _socket;
  final List<StatusUpdateCallback> _listeners = [];

  void connect() {
    if (_socket != null && _socket!.connected) return;

    _socket = io.io(
      AppConstants.apiBaseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      // Conectado com sucesso ao socket do Docker Drinks
    });

    _socket!.on('order_status_update', (data) {
      if (data is Map) {
        final saleId = data['saleId'] is int
            ? data['saleId']
            : int.tryParse(data['saleId'].toString()) ?? 0;
        final status = data['status']?.toString() ?? '';
        for (final listener in _listeners) {
          listener(saleId, status);
        }
      }
    });
  }

  void addListener(StatusUpdateCallback callback) {
    _listeners.add(callback);
  }

  void removeListener(StatusUpdateCallback callback) {
    _listeners.remove(callback);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _listeners.clear();
  }
}
