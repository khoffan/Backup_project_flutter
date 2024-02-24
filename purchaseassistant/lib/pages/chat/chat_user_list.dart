import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/services/chat_services.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/utils/constants.dart';

import 'chat_screen.dart';

class ListUserchat extends StatefulWidget {
  const ListUserchat({super.key});

  @override
  State<ListUserchat> createState() => _ListUserchatState();
}

class _ListUserchatState extends State<ListUserchat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  bool isRiderStatus = false;

  void getStatusrider(String senderid) async {
    bool isStatus = await APIMatiching().geyStatusRider(senderid);
    setState(() {
      isRiderStatus = isStatus;
    });
    print(isRiderStatus);
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    getStatusrider(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แชต",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: themeBg,
      ),
      body: _buildShowUser(),
    );
  }

  Widget _buildShowUser() {
    return StreamBuilder(
      stream: _firestore.collection('chat_rooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((docs) => _listUser(docs)).toList(),
        );
      },
    );
  }

  Widget _listUser(DocumentSnapshot docs) {
    Map<String, dynamic> data = docs.data() as Map<String, dynamic>;
    String revicedId = data["reciveData"]["riderid"];
    String senderid = data["senderData"]["cusid"];
    String senderName = data["senderData"]["cusname"];
    if (uid.trim() == revicedId.trim() && uid.trim() != senderid.trim()) {
      return Card(
        child: ListTile(
          title: Text("ผู้ส่ง${data["senderData"]["cusname"]}"),
          subtitle: Text("ผู้รับ${data["reciveData"]["ridername"]}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(reciveuid: senderid, name: senderName),
              ),
            );
          },
        ),
      );
    }
    if (uid.trim() != revicedId.trim() && uid.trim() == senderid.trim()) {
      return Card(
        child: ListTile(
          title: Text("ผู้ส่ง${data["senderData"]["cusname"]}"),
          subtitle: Text("ผู้รับ${data["reciveData"]["ridername"]}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(reciveuid: revicedId, name: senderName),
              ),
            );
          },
        ),
      );
    }
    return Container();
  }
}
