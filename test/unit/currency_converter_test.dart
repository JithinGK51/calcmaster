import 'package:flutter_test/flutter_test.dart';
import 'package:calcmaster/core/currency_converter.dart';

void main() {
  group('CurrencyConverter', () {
    test('should convert between currencies correctly', () {
      expect(CurrencyConverter.convert(100, 'USD', 'EUR'), closeTo(85.0, 1.0));
      expect(CurrencyConverter.convert(100, 'USD', 'GBP'), closeTo(75.0, 1.0));
      expect(CurrencyConverter.convert(100, 'USD', 'JPY'), closeTo(11000.0, 100.0));
    });

    test('should handle same currency conversion', () {
      expect(CurrencyConverter.convert(100, 'USD', 'USD'), 100.0);
      expect(CurrencyConverter.convert(50, 'EUR', 'EUR'), 50.0);
    });

    test('should handle zero amount', () {
      expect(CurrencyConverter.convert(0, 'USD', 'EUR'), 0.0);
      expect(CurrencyConverter.convert(0, 'GBP', 'JPY'), 0.0);
    });

    test('should handle negative amounts', () {
      expect(CurrencyConverter.convert(-100, 'USD', 'EUR'), closeTo(-85.0, 1.0));
      expect(CurrencyConverter.convert(-50, 'GBP', 'USD'), closeTo(-66.67, 1.0));
    });

    test('should handle large amounts', () {
      expect(CurrencyConverter.convert(1000000, 'USD', 'EUR'), closeTo(850000.0, 1000.0));
      expect(CurrencyConverter.convert(1000000, 'USD', 'JPY'), closeTo(110000000.0, 100000.0));
    });

    test('should handle small amounts', () {
      expect(CurrencyConverter.convert(0.01, 'USD', 'EUR'), closeTo(0.0085, 0.001));
      expect(CurrencyConverter.convert(0.01, 'USD', 'JPY'), closeTo(1.1, 0.1));
    });

    test('should get exchange rate correctly', () {
      expect(CurrencyConverter.getExchangeRate('USD', 'EUR'), closeTo(0.85, 0.01));
      expect(CurrencyConverter.getExchangeRate('USD', 'GBP'), closeTo(0.75, 0.01));
      expect(CurrencyConverter.getExchangeRate('USD', 'JPY'), closeTo(110.0, 1.0));
    });

    test('should handle reverse exchange rates', () {
      final usdToEur = CurrencyConverter.getExchangeRate('USD', 'EUR');
      final eurToUsd = CurrencyConverter.getExchangeRate('EUR', 'USD');
      expect(usdToEur * eurToUsd, closeTo(1.0, 0.01));
    });

    test('should get supported currencies', () {
      final currencies = CurrencyConverter.getSupportedCurrencies();
      expect(currencies, contains('USD'));
      expect(currencies, contains('EUR'));
      expect(currencies, contains('GBP'));
      expect(currencies, contains('JPY'));
      expect(currencies.length, greaterThan(10));
    });

    test('should check if currency is supported', () {
      expect(CurrencyConverter.isSupported('USD'), true);
      expect(CurrencyConverter.isSupported('EUR'), true);
      expect(CurrencyConverter.isSupported('GBP'), true);
      expect(CurrencyConverter.isSupported('INVALID'), false);
    });

    test('should handle invalid currency codes', () {
      expect(() => CurrencyConverter.convert(100, 'INVALID', 'USD'), throwsArgumentError);
      expect(() => CurrencyConverter.convert(100, 'USD', 'INVALID'), throwsArgumentError);
      expect(() => CurrencyConverter.getExchangeRate('INVALID', 'USD'), throwsArgumentError);
    });

    test('should handle major currency conversions', () {
      // Test major currency pairs
      expect(CurrencyConverter.convert(100, 'USD', 'CAD'), closeTo(125.0, 1.0));
      expect(CurrencyConverter.convert(100, 'USD', 'AUD'), closeTo(135.0, 1.0));
      expect(CurrencyConverter.convert(100, 'USD', 'CHF'), closeTo(92.0, 1.0));
      expect(CurrencyConverter.convert(100, 'USD', 'CNY'), closeTo(645.0, 5.0));
    });

    test('should handle Asian currencies', () {
      expect(CurrencyConverter.convert(100, 'USD', 'INR'), closeTo(7400.0, 100.0));
      expect(CurrencyConverter.convert(100, 'USD', 'KRW'), closeTo(118000.0, 1000.0));
      expect(CurrencyConverter.convert(100, 'USD', 'SGD'), closeTo(134.0, 1.0));
    });

    test('should handle European currencies', () {
      expect(CurrencyConverter.convert(100, 'EUR', 'GBP'), closeTo(88.24, 1.0));
      expect(CurrencyConverter.convert(100, 'EUR', 'CHF'), closeTo(108.24, 1.0));
      expect(CurrencyConverter.convert(100, 'EUR', 'SEK'), closeTo(1011.76, 10.0));
    });

    test('should handle Middle Eastern currencies', () {
      expect(CurrencyConverter.convert(100, 'USD', 'AED'), closeTo(367.0, 1.0));
      expect(CurrencyConverter.convert(100, 'USD', 'SAR'), closeTo(375.0, 1.0));
      expect(CurrencyConverter.convert(100, 'USD', 'KWD'), closeTo(30.0, 1.0));
    });

    test('should handle African currencies', () {
      expect(CurrencyConverter.convert(100, 'USD', 'ZAR'), closeTo(1500.0, 10.0));
      expect(CurrencyConverter.convert(100, 'USD', 'EGP'), closeTo(1570.0, 10.0));
    });

    test('should handle South American currencies', () {
      expect(CurrencyConverter.convert(100, 'USD', 'BRL'), closeTo(520.0, 5.0));
      expect(CurrencyConverter.convert(100, 'USD', 'MXN'), closeTo(2000.0, 10.0));
    });

    test('should handle precision in conversions', () {
      final result1 = CurrencyConverter.convert(1, 'USD', 'JPY');
      final result2 = CurrencyConverter.convert(0.01, 'USD', 'JPY');
      expect(result1, closeTo(110.0, 1.0));
      expect(result2, closeTo(1.1, 0.1));
    });

    test('should handle currency symbols', () {
      expect(CurrencyConverter.getCurrencySymbol('USD'), '\$');
      expect(CurrencyConverter.getCurrencySymbol('EUR'), '€');
      expect(CurrencyConverter.getCurrencySymbol('GBP'), '£');
      expect(CurrencyConverter.getCurrencySymbol('JPY'), '¥');
    });

    test('should handle currency names', () {
      expect(CurrencyConverter.getCurrencyName('USD'), 'US Dollar');
      expect(CurrencyConverter.getCurrencyName('EUR'), 'Euro');
      expect(CurrencyConverter.getCurrencyName('GBP'), 'British Pound');
      expect(CurrencyConverter.getCurrencyName('JPY'), 'Japanese Yen');
    });

    test('should handle invalid currency symbols and names', () {
      expect(CurrencyConverter.getCurrencySymbol('INVALID'), '');
      expect(CurrencyConverter.getCurrencyName('INVALID'), '');
    });
  });
}
