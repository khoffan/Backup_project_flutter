import 'package:cloud_firestore/cloud_firestore.dart';

String FormatDate(Timestamp timestamp) {
  DateTime datetime = timestamp.toDate();

  String year = datetime.year.toString();
  String mount = datetime.month.toString();
  String day = datetime.day.toString();
  String formatDate = '$year/$mount/$day';
  return formatDate;
}
