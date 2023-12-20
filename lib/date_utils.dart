import 'package:intl/intl.dart';

class DateTimeUtils {
  static final dateFormat = DateFormat.yMd();

  static String getFormattedDateFromMilli(int milliseconds) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return getFormattedDateFromDateTime(date);
  }

  static String getFormattedDateFromDateTime(DateTime dateTime) {
    var formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }
}
