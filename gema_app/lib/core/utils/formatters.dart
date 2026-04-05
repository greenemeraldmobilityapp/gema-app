import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _rupiahFormat.format(amount);
  }

  static String formatInt(int amount) {
    return _rupiahFormat.format(amount);
  }

  static String formatShort(double amount) {
    if (amount >= 1000000) {
      return 'Rp${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return format(amount);
  }
}

class DateFormatter {
  DateFormatter._();

  static final DateFormat _fullFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  static final DateFormat _shortFormat = DateFormat('d MMM yyyy', 'id_ID');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');
  static final DateFormat _apiFormat = DateFormat('yyyy-MM-dd');

  static String formatFull(DateTime date) {
    return _fullFormat.format(date);
  }

  static String formatShort(DateTime date) {
    return _shortFormat.format(date);
  }

  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String formatApi(DateTime date) {
    return _apiFormat.format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d lalu';
    } else {
      return formatShort(date);
    }
  }
}

class NumberFormatter {
  NumberFormatter._();

  static final NumberFormat _decimalFormat = NumberFormat('#,###');
  static final NumberFormat _percentFormat = NumberFormat.percentPattern('id_ID');

  static String formatDecimal(int number) {
    return _decimalFormat.format(number);
  }

  static String formatPercent(double percent) {
    return _percentFormat.format(percent / 100);
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}
