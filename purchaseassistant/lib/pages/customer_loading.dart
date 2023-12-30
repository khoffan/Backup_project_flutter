import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';
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

  void connectMatchingResult() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("customerData").doc(currid).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (data["rider_status"] == true) {
          String reciveuid = data["riderid"];
          String name = data["ridername"];
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
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
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
    connectMatchingResult();
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
