import 'package:fintrack/core/utils/currency_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyParser', () {
    test('deve retornar null para entrada vazia', () {
      expect(CurrencyParser.parse(''), isNull);
      expect(CurrencyParser.parse('   '), isNull);
    });

    test('deve converter valor em formato brasileiro para double', () {
      expect(CurrencyParser.parse('12,34'), 12.34);
      expect(CurrencyParser.parse('1.234,56'), 1234.56);
      expect(CurrencyParser.parse('0,99'), 0.99);
    });

    test('deve retornar null para valor invalido', () {
      expect(CurrencyParser.parse('abc'), isNull);
      expect(CurrencyParser.parse('valor invalido'), isNull);
    });

    test('deve formatar double como moeda brasileira sem simbolo', () {
      expect(CurrencyParser.format(12.34), '12,34');
      expect(CurrencyParser.format(1234.56), '1.234,56');
      expect(CurrencyParser.format(0.99), '0,99');
    });

    test('deve formatar double como moeda brasileira com simbolo', () {
      expect(CurrencyParser.formatWithSymbol(12.34), 'R\$ 12,34');
      expect(CurrencyParser.formatWithSymbol(1234.56), 'R\$ 1.234,56');
      expect(CurrencyParser.formatWithSymbol(0.99), 'R\$ 0,99');
    });
  });
}
