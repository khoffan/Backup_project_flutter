import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? senderId;
  String? recivesid;
  String? name;
  String? message;
  Timestamp? timestamp;

  Message({this.senderId, this.recivesid,this.name, this.message, this.timestamp});

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'senderId': senderId,
      'recivesid': recivesid,
      'name': name,
      'message': message,
      'timestamp': timestamp
    };
  }
}