import 'package:intl/intl.dart';

String formatDateTodMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}
