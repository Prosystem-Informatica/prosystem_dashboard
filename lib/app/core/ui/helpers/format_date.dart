import 'package:intl/intl.dart';


String formatDate(DateTime date) {
  final format = DateFormat('dd/MM/yyyy'); // Define o formato da data
  return format.format(date);
}


String formatMMYYYY(String input) {
  String cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');

  if (cleaned.length < 2) {
    return cleaned;
  }

  String month = cleaned.substring(0, 2);
  String year = cleaned.length > 2 ? cleaned.substring(2) : '';

  if (year.length > 4) {
    year = year.substring(0, 4);
  }

  return '$month/$year';
}

String formatAndValidateMMYYYY(String input) {
  String formatted = formatMMYYYY(input);

  if (formatted.length >= 2) {
    int month = int.tryParse(formatted.substring(0, 2)) ?? 0;
    if (month < 1 || month > 12) {
      throw FormatException('Mês inválido. Deve estar entre 01 e 12.');
    }
  }

  return formatted;
}