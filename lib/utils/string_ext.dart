extension StringExt on String? {
  String get cleanedText =>
      (this ?? '').trim().replaceAll(RegExp(r'\s+\b|\b\s'), ' ');
}