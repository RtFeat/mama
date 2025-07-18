import 'package:intl/intl.dart';

extension StringExtension on String {
  DateTime get timeToDateTime {
    final dateTimeFormat = DateFormat('HH:mm');
    return dateTimeFormat.parse(this);
  }
}
