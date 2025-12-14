extension StringExt on String? {
  String orDefault([String defaultValue = ""]) {
    return this ?? defaultValue;
  }
}
