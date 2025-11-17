import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

class DateUtilsExt {
  DateUtilsExt._();

  static String formatDate(DateTime date, {String? pattern}) {
    final formatter = DateFormat(pattern ?? AppConstants.dateFormat);
    return formatter.format(date);
  }
}
