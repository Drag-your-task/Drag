import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy.MM.dd');
  return formatter.format(dateTime);
}