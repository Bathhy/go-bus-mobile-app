extension DateFormatter on String {
  String toReadableDate() {
    final dateTime = DateTime.parse(this);
    final day = dateTime.day;
    final year = dateTime.year % 100; // Last two digits
    final month = _monthName(dateTime.month);
    return "$day $month, ${year.toString().padLeft(2, '0')}";
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}

extension DateTimeFormatter on DateTime {
  String toReadableDate() {
    final day = this.day;
    final year = this.year % 100; // Last two digits
    final month = _monthName(this.month);
    return "$day $month, ${year.toString().padLeft(2, '0')}";
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}
