import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? senderId;
  String? recivesid;
  String? postDocid;
  String? name;
  String? message;
  Timestamp? timestamp;

  Message({this.senderId, this.recivesid,this.postDocid,this.name, this.message, this.timestamp});

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'senderId': senderId,
      'recivesid': recivesid,
      'postdocid': postDocid,
      'name': name,
      'message': message,
      'timestamp': timestamp
    };
  }
}