import 'package:cloud_firestore/cloud_firestore.dart';

class FormatDate {
  static String date(Timestamp timestamp) {
    DateTime datetime = timestamp.toDate();
    // Map<String, dynamic> mountName = {
    //   "1": "มกราคม",
    //   "2": "กุมภาพันธ์",
    //   "3": "มีนาคม",
    //   "4": "เมษายน",
    //   "5": "พฤษภาคม",
    //   "6": "มิถุนายน",
    //   "7": "กรกฎาคม",
    //   "8": "สิงหาคม",
    //   "9": "กันยายน",
    //   "10": "ตุลาคม",
    //   "11": "พฤศจิกายน",
    //   "12": "ธันวาคม",
    // };
    String year = datetime.year.toString().padLeft(4, '0');
    String month = datetime.month.toString().padLeft(2, '0');
    String day = datetime.day.toString().padLeft(2, '0');
    String hour = datetime.hour.toString().padLeft(2, '0');
    String minute = datetime.minute.toString().padLeft(2, '0');
    String second = datetime.second.toString().padLeft(2, '0');
    String formatDate = '$year-$month-$day $hour:$minute:$second';
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
