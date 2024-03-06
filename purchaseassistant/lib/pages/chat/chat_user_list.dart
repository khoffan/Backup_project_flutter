import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/models/stremCheckingData.dart';
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
  late StreamSubscription<bool> _stremCheckData;
  String uid = "";
  bool isRiderStatus = false;
  bool isData = false;

  void getStatusrider(String senderid) async {
    bool isStatus = await APIMatiching().geyStatusRider(senderid);
    setState(() {
      isRiderStatus = isStatus;
    });
    print(isRiderStatus);
  }

  void streamCheckData() {
    _stremCheckData =
        APIMatiching().getRiderStatus(uid).listen((bool isStatus) {
      setState(() {
        isData = isStatus;
      });
      print(isData);
    });
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    getStatusrider(uid);
    streamCheckData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stremCheckData.cancel();
  }

  Widget showCOntentUsechat() {
    final StremChecingData streamDatauser = _buildShowUser(context);
    return streamDatauser.hasdata != false
        ? streamDatauser.widget
        : Center(
            child: Text("nodata"),
          );
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
      body: showCOntentUsechat(),
    );
  }

  StremChecingData _buildShowUser(BuildContext context) {
    bool hasdata = true;
    return StremChecingData(
        hasdata: hasdata,
        widget: StreamBuilder(
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

            if (!snapshot.hasData) {
              hasdata = false;
              return Center(
                child: Text("No data in collection"),
              );
            }

            final contentChatDocs = snapshot.data!.docs;
            if (snapshot.hasData && contentChatDocs.isNotEmpty) {
              return ListView(
                children: contentChatDocs.map((contentChatDoc) {
                  Map<String, dynamic> contentChatData =
                      contentChatDoc.data() as Map<String, dynamic>;
                  return _listUser(contentChatData);
                }).toList(),
              );
            } else {
              return Center(
                child: Text(
                  !hasdata ? "ไม่มีรายการห้องแชต" : "ไม่มีรายการห้องแชต",
                  style: TextStyle(fontSize: 25),
                ),
              );
            }
          },
        ));
  }

  Widget _listUser(Map<String, dynamic> data) {
    String revicedId = data["reciveData"]["riderid"];
    String senderid = data["senderData"]["cusid"];
    String senderName = data["senderData"]["cusname"];
    // if (uid.trim() == revicedId.trim() &&
    //     uid.trim() != senderid.trim() &&
    //     isData == true) {
    //   return Card(
    //     child: ListTile(
    //       title: Text("ผู้ส่ง${data["senderData"]["cusname"]}"),
    //       subtitle: Text("ผู้รับ${data["reciveData"]["ridername"]}"),
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (_) =>
    //                 ChatScreen(reciveuid: senderid, name: senderName),
    //           ),
    //         );
    //       },
    //     ),
    //   );
    // }
    if (uid.trim() != revicedId.trim() &&
        uid.trim() == senderid.trim() &&
        isData == true) {
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
