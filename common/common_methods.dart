String? validateText(String? value) {
  if (value!.isEmpty) return 'Please fill out this field';
  if (value.length > 300) return 'Consider changing your name';
  return null;
}
