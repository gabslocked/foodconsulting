import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _brlFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );
  
  static final NumberFormat _usdFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );
  
  static final NumberFormat _eurFormat = NumberFormat.currency(
    locale: 'de_DE',
    symbol: '€',
    decimalDigits: 2,
  );
  
  static String formatBRL(double value) {
    return _brlFormat.format(value);
  }
  
  static String formatUSD(double value) {
    return _usdFormat.format(value);
  }
  
  static String formatEUR(double value) {
    return _eurFormat.format(value);
  }
  
  static String formatCurrency(double value, String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'BRL':
        return formatBRL(value);
      case 'USD':
        return formatUSD(value);
      case 'EUR':
        return formatEUR(value);
      default:
        return NumberFormat.currency(
          symbol: currencyCode,
          decimalDigits: 2,
        ).format(value);
    }
  }
  
  static String formatExchangeRate(double rate, String fromCurrency, String toCurrency) {
    return '1 $fromCurrency = ${formatCurrency(rate, toCurrency)}';
  }
}
