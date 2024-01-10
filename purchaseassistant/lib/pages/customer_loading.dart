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
  String reciveuid = "";
  String name = "";
  bool? isLoading;
  bool isFunc = false;
  late StreamSubscription<Map<String, dynamic>> streamData;

  _showAlert(String uid) {
    if (mounted) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: "จับคู่สำเร็จ",
        text: "คุณยอมรับการจับคู่หรือไม่",
        confirmBtnText: 'ตกลง',
        cancelBtnText: "ยกเลิก",
        onConfirmBtnTap: () {
          setState(() {
            isLoading = true;
          });
          APIMatiching().updateStatusChatCustomer(uid);
          Navigator.pop(context);
        },
        confirmBtnColor: Colors.green,
        onCancelBtnTap: () {
          APIMatiching().updateStatusCustomer(uid);
          Navigator.pop(context);
        },
      );
    }
  }

  void connectMatchingResult() {
    try {
      if (!isFunc && currid != "") {
        streamData = APIMatiching().getData(currid).listen(
          (Map<String, dynamic> snapshotData) {
            if (snapshotData["rider_status"] == true && isLoading == false) {
              name = snapshotData["ridername"];
              reciveuid = snapshotData["riderid"];
              _showAlert(uid);
            }
          },
          onError: (dynamic error) {
            print("Error: ${error}");
          },
          onDone: () {
            print("Stream is closed");
          },
        );
        isFunc = true;
      } else {
        print("Document not updated");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    setState(() {
      isLoading = false;
    });
    super.initState();
    if (_auth.currentUser != null) {
      uid = _auth.currentUser!.uid;
      currid = widget.riderid ?? "";
    } else {
      print("User not authenticated");
    }
    connectMatchingResult();
  }

  @override
  void dispose() {
    super.dispose();
    streamData.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading != true
          ? Container(
              color: Colors.white,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "รอการจับคู่...",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          textBaseline: null),
                    ),
                  ]),
            )
          : ChatScreen(reciveuid: reciveuid, name: name),
    );
  }
}
