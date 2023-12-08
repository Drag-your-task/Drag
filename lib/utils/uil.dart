import 'package:intl/intl.dart';

List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

List<String> months = ['January', 'Feburary', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];


String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy.MM.dd');
  return formatter.format(dateTime);
}