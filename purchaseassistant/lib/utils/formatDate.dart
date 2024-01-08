import 'package:cloud_firestore/cloud_firestore.dart';

String FormatDate(Timestamp timestamp) {
  DateTime datetime = timestamp.toDate();

  String year = datetime.year.toString();
  String mount = datetime.month.toString();
  String day = datetime.day.toString();
  String hour = datetime.hour.toString();
  String minute = datetime.minute.toString();
  String secound = datetime.second.toString();
  String formatDate = '$year/$mount/$day $hour:$minute:$secound';
  return formatDate;
}
