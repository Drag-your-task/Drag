import 'package:intl/intl.dart';

List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy.MM.dd');
  return formatter.format(dateTime);
}