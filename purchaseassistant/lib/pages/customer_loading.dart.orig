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
<<<<<<< HEAD
        DocumentSnapshot snapshot =
            await _firestore.collection("customerData").doc(currid).get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          if (currstatus == true) {
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
          } else {
            Future.delayed(Duration(seconds: 10), () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                text: 'ตอนนนี้ไม่ผู้ให้บริการ คุณต้องการที่จะจับคู่ต่อหรือไม่',
                confirmBtnText: 'ตกลง',
                cancelBtnText: 'ยกเลิก',
                confirmBtnColor: Colors.green,
              );
            });
          }
        }
=======
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
                  APIMatiching().updateStatusChatCustomer(uid);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChatScreen(reciveuid: reciveuid, name: name)));
                },
                confirmBtnColor: Colors.green,
                onCancelBtnTap: () {
                  APIMatiching().updateStatusCustomer(uid);
                  Navigator.pop(context);
                },
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
>>>>>>> 3d25233523b789543cbe5f1a07ead0a6837b3eeb
      } else {
        print("Document not updated");
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void getStatus(BuildContext context, String uid) async {
    try {
<<<<<<< HEAD
      stream = APIMatiching().getStatusRider(uid).listen((bool status) {
        if (status == true) {
          setState(() {
            currstatus = status;
          });
        }
      }, onError: (dynamic error) {
        print("Error: ${error}");
      }, onDone: () {
        print("Stream is close");
      });
=======
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
>>>>>>> 3d25233523b789543cbe5f1a07ead0a6837b3eeb
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
    return Scaffold(
      appBar: AppBar(
        title: Text('รอการจับคู่'),
      ),
      body: Container(
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
                    fontSize: 14, color: Colors.black, textBaseline: null),
              ),
            ]),
      ),
    );
  }
}
