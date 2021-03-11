import 'package:intl/intl.dart';

String? validateName(String? value) {
  if (value!.isEmpty) return 'Please fill out this field';
  if (value.length > 300) return 'Consider changing your name';
  return null;
}

String? convertDate(DateTime? valueToConvert) {
  var format = DateFormat.yMd();
  return format.format(valueToConvert!);
}
