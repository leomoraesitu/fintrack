import 'package:intl/intl.dart';

class CurrencyParser {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: '',
    decimalDigits: 2,
  );

  static final NumberFormat _symbolFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static double? parse(String input) {
    try {
      final cleaned = input.trim();

      if (cleaned.isEmpty) return null;

      return _formatter.parse(cleaned).toDouble();
    } catch (_) {
      return null;
    }
  }

  static String format(double value) {
    return _formatter.format(value).trim();
  }

  static String formatWithSymbol(double value) {
    return _symbolFormatter.format(value).replaceAll('\u00A0', ' ').trim();
  }
}
