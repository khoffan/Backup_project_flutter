import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/models/message.dart';

class ChatServices extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessge(
      String recivesid, String message, String docid) async {
    try {
      final String currentid = _auth.currentUser?.uid ?? '';
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('userProfile').doc(currentid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      final Timestamp _time = Timestamp.now();
      print(recivesid);

      Message? newMessage;
      if (recivesid != '' && currentid != '' && message != '') {
        newMessage = Message(
          senderId: currentid,
          recivesid: recivesid,
          postDocid: docid,
          name: data["name"] ?? "",
          message: message,
          timestamp: _time,
        );
      }

      List<String> ids = [currentid, docid];
      ids.sort();
      String chat_roomid = ids.join("_");

      await _firestore
          .collection('chat_rooms')
          .doc(chat_roomid)
          .collection('messages')
          .add(newMessage!.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot> getMessage(
      String userid, String otherid, String docid) {
    List<String> ids = [userid, docid];
    ids.sort();
    String chat_room_id = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chat_room_id)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
