import 'package:intl/intl.dart';

extension NumExtensions on num {
  num plus(num other) {
    return this + other;
  }

  num minus(num other) {
    return this - other;
  }

  num times(num other) {
    return this * other;
  }

  num div(num other) {
    return this / other;
  }
}

extension IntExtensions on int {
  int plus(int other) {
    return this + other;
  }

  int minus(int other) {
    return this - other;
  }

  int times(int other) {
    return this * other;
  }

  double div(int other) {
    return this / other;
  }

  int truncateDiv(int other) {
    return this ~/ other;
  }
}

extension DoubleExtensions on double {
  double plus(double other) {
    return this + other;
  }

  double minus(double other) {
    return this - other;
  }

  double times(double other) {
    return this * other;
  }

  double div(double other) {
    return this / other;
  }

  String formatCurrency({String symbol = 'VND', String locale = 'vi'}) {
    String currency = NumberFormat.currency(symbol: '', locale: locale).format(this);
    return '${currency.substring(0, currency.length - 1)}$symbol';
  }

  String convertToUSD() {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0);
    return formatter.format(this);
  }
}
