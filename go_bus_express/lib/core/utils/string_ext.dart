String minutesToHours(int minutes) {
  final hours = minutes ~/ 60;
  return '${hours}h';
}

extension StringExt on String? {
  String orDefault([String defaultValue = ""]) {
    return this ?? defaultValue;
  }
}
