import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount, {String symbol = 'UGX '}) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '$symbol${formatter.format(amount)}';
  }

  static String formatNumber(dynamic number) {
    if (number == null) return '0';
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(number);
  }

  static String formatDate(DateTime? date, {String format = 'dd MMM yyyy'}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy HH:mm').format(date);
  }

  static String getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final names = name.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF2994A);
      case 'filled':
      case 'completed':
        return const Color(0xFF27AE60);
      case 'expired':
      case 'cancelled':
        return const Color(0xFFEB5757);
      default:
        return const Color(0xFF828282);
    }
  }
}