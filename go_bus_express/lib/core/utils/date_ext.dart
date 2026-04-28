import 'package:intl/intl.dart';

/// Extension methods for DateTime to handle common date formatting
extension DateTimeExt on DateTime {
  /// Format date as LocalDate string (yyyy-MM-dd)
  /// Example: 2026-04-28
  /// This format is compatible with Java LocalDate
  String toLocalDateString() {
    return '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }

  /// Format date as readable string (EEE, MMM d, yyyy)
  /// Example: Mon, Apr 28, 2026
  String toReadableDate() {
    return DateFormat('EEE, MMM d, yyyy').format(this);
  }

  /// Format time as HH:mm
  /// Example: 14:30
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format date and time as readable string
  /// Example: Mon, Apr 28, 2026 at 14:30
  String toReadableDateTime() {
    return DateFormat('EEE, MMM d, yyyy \'at\' HH:mm').format(this);
  }
}

/// Extension methods for String to parse dates
extension DateStringExt on String {
  /// Parse ISO 8601 string to DateTime
  /// Handles both with and without time component
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Parse and format ISO 8601 string to LocalDate string (yyyy-MM-dd)
  String? toLocalDateString() {
    final dt = toDateTime();
    return dt?.toLocalDateString();
  }

  /// Parse and format ISO 8601 string to readable date
  String? toReadableDate() {
    final dt = toDateTime();
    return dt?.toReadableDate();
  }

  /// Parse and format ISO 8601 string to time (HH:mm)
  String? toTimeString() {
    final dt = toDateTime();
    return dt?.toTimeString();
  }
}
