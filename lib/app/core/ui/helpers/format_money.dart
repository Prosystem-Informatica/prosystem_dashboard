import 'package:intl/intl.dart';

String formatCurrency(
    String value, {
      bool toDollar = false,
      double exchangeRate = 5.0,
    }) {
  try {
    final cleanValue = value
        .replaceAll('.', '')
        .replaceAll(',', '.');

    final numericValue = double.parse(cleanValue);

    final valueToFormat = toDollar ? numericValue / exchangeRate : numericValue;

    final format = toDollar
        ? NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
      locale: 'en_US',
    )
        : NumberFormat.currency(
      symbol: 'R\$',
      decimalDigits: 2,
      locale: 'pt_BR',
    );

    //print("Valor formatado > ${format.format(valueToFormat)}");

    return format.format(valueToFormat);
  } catch (e) {
    print('Erro na formatação: $e');
    return value;
  }
}