import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/models/message.dart';

class ChatServices extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessge(String recivesid, String message) async {
    try {
      final String currentid = _auth.currentUser?.uid ?? '';
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Profile').doc(currentid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      final Timestamp _time = Timestamp.now();

      Message? newMessage;
      if (currentid != '' && message != '') {
        newMessage = Message(
          senderId: currentid,
          recivesid: recivesid,
          name: data["name"] ?? "",
          message: message,
          timestamp: _time,
        );
      }
      List<String> ids = [currentid, recivesid];
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

  Future<void> setChatroomData(String currentid, String recivesid,
      Map<String, dynamic> cusdata, Map<String, dynamic> riderdata) async {
    try {
      List<String> ids = [currentid, recivesid];
      ids.sort();
      String chat_roomid = ids.join("_");
      await _firestore
          .collection('chat_rooms')
          .doc(chat_roomid)
          .set({"senderData": cusdata, "reciveData": riderdata});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> getChatRoomid(String currid, String recivedid) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("chat_rooms").get();
      if (snapshot.docs.isNotEmpty) {
        final datadoc = snapshot.docs;
        for (DocumentSnapshot data in datadoc) {
          if (data["senderData"]["cusid"] == currid &&
              data["reciveData"]["riderid"] == recivedid) {
            return data.id;
          }
        }
      }
      return "";
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<QuerySnapshot> getMessage(String userid, String otherid) {
    List<String> ids = [userid, otherid];
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
