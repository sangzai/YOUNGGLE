import 'package:intl/intl.dart';

class DateFormatUtil {
  String formattedDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    // Format the date using intl package
    final dateFormat = DateFormat('MM/dd (E)','ko_KR');
    return dateFormat.format(date);
  }
}