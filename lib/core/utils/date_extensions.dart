extension DateTimeX on DateTime {
  /// Strips time component — always store food log dates at midnight.
  /// Never use DateTime.now() directly as a date field.
  DateTime toMidnight() => DateTime(year, month, day);

  /// Returns true if this date is the same calendar day as [other].
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Returns a display string like "Today", "Yesterday", or "Mon, Apr 21".
  String toDisplayLabel() {
    final now = DateTime.now();
    if (isSameDay(now)) return 'Today';
    if (isSameDay(now.subtract(const Duration(days: 1)))) return 'Yesterday';
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${weekdays[weekday - 1]}, ${months[month - 1]} $day';
  }
}
