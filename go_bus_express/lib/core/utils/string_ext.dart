String minutesToHours(int minutes) {
  final hours = minutes ~/ 60;
  return '${hours}h';
}

extension StringExt on String? {
  String orDefault([String defaultValue = ""]) {
    return this ?? defaultValue;
  }
}

extension StringFormattedTimeExt on String? {
  String formattedTime() {
    if (this == null || this!.isEmpty) return "";
    return this!.replaceAll(' ', '').substring(0, 5);
  }
}
