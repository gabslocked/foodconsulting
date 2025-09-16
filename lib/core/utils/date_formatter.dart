import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat _dayMonthYearTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _timeOnly = DateFormat('HH:mm');
  static final DateFormat _dayMonth = DateFormat('dd/MM');
  static final DateFormat _monthYear = DateFormat('MM/yyyy');
  static final DateFormat _weekday = DateFormat('EEEE', 'pt_BR');
  static final DateFormat _fullDate = DateFormat('EEEE, dd \'de\' MMMM \'de\' yyyy', 'pt_BR');
  
  static String formatDate(DateTime date) {
    return _dayMonthYear.format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return _dayMonthYearTime.format(dateTime);
  }
  
  static String formatTime(DateTime time) {
    return _timeOnly.format(time);
  }
  
  static String formatDayMonth(DateTime date) {
    return _dayMonth.format(date);
  }
  
  static String formatMonthYear(DateTime date) {
    return _monthYear.format(date);
  }
  
  static String formatWeekday(DateTime date) {
    return _weekday.format(date);
  }
  
  static String formatFullDate(DateTime date) {
    return _fullDate.format(date);
  }
  
  static String formatDateRange(DateTime start, DateTime end) {
    final startFormat = DateFormat('dd MMM', 'pt_BR');
    final endFormat = DateFormat('dd MMM yyyy', 'pt_BR');
    
    if (start.year == end.year && start.month == end.month) {
      return '${start.day}-${end.day} ${DateFormat('MMM yyyy', 'pt_BR').format(end)}';
    } else if (start.year == end.year) {
      return '${startFormat.format(start)} - ${endFormat.format(end)}';
    }
    return '${startFormat.format(start)} - ${endFormat.format(end)}';
  }
  
  static String formatDateRangeCompact(DateTime start, DateTime end) {
    final monthNames = {
      1: 'Jan', 2: 'Fev', 3: 'Mar', 4: 'Abr', 5: 'Mai', 6: 'Jun',
      7: 'Jul', 8: 'Ago', 9: 'Set', 10: 'Out', 11: 'Nov', 12: 'Dez'
    };
    
    if (start.year == end.year && start.month == end.month) {
      return '${start.day}-${end.day} ${monthNames[end.month]}';
    } else if (start.year == end.year) {
      return '${start.day} ${monthNames[start.month]} - ${end.day} ${monthNames[end.month]}';
    }
    return '${start.day} ${monthNames[start.month]} ${start.year} - ${end.day} ${monthNames[end.month]} ${end.year}';
  }
  
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Amanhã';
    } else if (difference == -1) {
      return 'Ontem';
    } else if (difference > 1 && difference <= 7) {
      return 'Em $difference dias';
    } else if (difference < -1 && difference >= -7) {
      return '${difference.abs()} dias atrás';
    } else {
      return formatDate(date);
    }
  }
}
