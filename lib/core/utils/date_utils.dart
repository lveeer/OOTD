import 'package:intl/intl.dart';

class AppDateUtils {
  static const String defaultDateFormat = 'yyyy-MM-dd';
  static const String defaultTimeFormat = 'HH:mm:ss';
  static const String defaultDateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  static String formatDate(DateTime? date, {String format = defaultDateFormat}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  static String formatTime(DateTime? date, {String format = defaultTimeFormat}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime? date, {String format = defaultDateTimeFormat}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}周前';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else {
      return '${(difference.inDays / 365).floor()}年前';
    }
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static DateTime? parseDate(String? dateStr, {String format = defaultDateFormat}) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateFormat(format).parse(dateStr);
    } catch (e) {
      return null;
    }
  }
}