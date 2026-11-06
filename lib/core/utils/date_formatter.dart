import 'package:intl/intl.dart';

class DateFormatter {
  static String standard(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String withTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy · hh:mm a').format(date);
  }

  static String monthYear(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMMM yyyy').format(date);
  }

  static String timeOnly(DateTime? date) {
    if (date == null) return '';
    return DateFormat('hh:mm a').format(date);
  }
}
