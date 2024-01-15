import 'package:cloud_firestore/cloud_firestore.dart';

class FormatDate {
  static String date(Timestamp timestamp) {
    DateTime datetime = timestamp.toDate();
    Map<String, dynamic> mountName = {
      "1": "มกราคม",
      "2": "กุมภาพันธ์",
      "3": "มีนาคม",
      "4": "เมษายน",
      "5": "พฤษภาคม",
      "6": "มิถุนายน",
      "7": "กรกฎาคม",
      "8": "สิงหาคม",
      "9": "กันยายน",
      "10": "ตุลาคม",
      "11": "พฤศจิกายน",
      "12": "ธันวาคม",
    };
    String year = datetime.year.toString();
    String mount = datetime.month.toString();
    String day = datetime.day.toString();
    String hour = datetime.hour.toString();
    String minute = datetime.minute.toString();
    String secound = datetime.second.toString();
    String formatDate = '$year/$mount/$day $hour:$minute:$secound';
    return formatDate;
  }

  static String getdaytime(Timestamp timestamp) {
    DateTime datetime = timestamp.toDate();
    Map<String, dynamic> mountName = {
      "1": "มกราคม",
      "2": "กุมภาพันธ์",
      "3": "มีนาคม",
      "4": "เมษายน",
      "5": "พฤษภาคม",
      "6": "มิถุนายน",
      "7": "กรกฎาคม",
      "8": "สิงหาคม",
      "9": "กันยายน",
      "10": "ตุลาคม",
      "11": "พฤศจิกายน",
      "12": "ธันวาคม",
    };
    String year = datetime.year.toString();
    String mount = mountName[datetime.month.toString()];
    String day = datetime.day.toString();
    String formatDate = '$day-$mount-$year';
    return formatDate;
  }
}
