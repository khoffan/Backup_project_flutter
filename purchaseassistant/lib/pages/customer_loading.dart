import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/services/wallet_service.dart';
import 'package:quickalert/quickalert.dart';

class LoadingCustomerScreen extends StatefulWidget {
  LoadingCustomerScreen({super.key, this.riderid});
  String? riderid;
  @override
  State<LoadingCustomerScreen> createState() => _CustomerLoadingScreenState();
}

class _CustomerLoadingScreenState extends State<LoadingCustomerScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  String currid = "";
  bool currstatus = false;
  late StreamSubscription<bool> stream;

  late StreamSubscription<Map<String, dynamic>> streamData;

  void connectMatchingResult() {
    try {
      if (currid != "") {
        streamData = APIMatiching().getData(currid).listen(
          (Map<String, dynamic> snapshotData) {
            if (snapshotData["rider_status"] == true) {
              String name = snapshotData["ridername"];
              String reciveuid = snapshotData["riderid"];
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                text: 'จับคู่สำเร็จ ยอมรับการจับคู่หรือไม่',
                confirmBtnText: 'ตกลง',
                cancelBtnText: "ยกเลิก",
                onConfirmBtnTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChatScreen(reciveuid: reciveuid, name: name)));
                },
                confirmBtnColor: Colors.green,
              );
            } else {}
          },
          onError: (dynamic error) {
            print("Error: ${error}");
          },
          onDone: () {
            print("Stream is closed");
          },
        );
      } else {
        print("Document not updated");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void getStatus(BuildContext context, String uid) async {
    try {
      stream = APIMatiching().getStatusRider(uid).listen(
        (bool status) {
          if (status == true) {
            setState(() {
              currstatus = status;
            });
          }
        },
        onError: (dynamic error) {
          print("Error: $error");
        },
        onDone: () {
          print("Stream is done");
        },
      );
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      uid = _auth.currentUser!.uid;
      currid = widget.riderid ?? "";
    } else {
      // Handle the case where _auth.currentUser is null, perhaps redirect to login
      // or take appropriate action for your application.
      print("User not authenticated");
    }
    getStatus(context, currid);
    print(currstatus);

    connectMatchingResult();
  }

  @override
  void dispose() {
    super.dispose();
    stream.cancel();
    streamData.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
            ]),
      ),
    );
  }
}
