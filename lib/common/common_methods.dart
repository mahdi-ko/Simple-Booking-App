import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? validateName(String? value) {
  if (value!.isEmpty) return 'Please fill out this field';
  if (value.length > 50) return 'Consider changing your name';
  return null;
}

String? convertDate(DateTime? valueToConvert) {
  var format = DateFormat.yMd();
  return format.format(valueToConvert!);
}

void removeFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

String convertTime(TimeOfDay time) {
  final t = time.toString();
  return t.substring(t.indexOf('(') + 1, t.indexOf(')'));
}
