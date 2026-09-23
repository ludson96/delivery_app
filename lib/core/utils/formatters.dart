import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(dynamic value) {
    if (value == null) return 'R\$ 0,00';
    final double numericValue = double.tryParse(value.toString()) ?? 0.0;
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(numericValue);
  }

  static String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '--/--/----';
    try {
      final dateTime = DateTime.parse(dateString).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(dateTime);
    } catch (_) {
      try {
        final dateTime = DateTime.parse(dateString);
        return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
      } catch (_) {
        return dateString;
      }
    }
  }
}
