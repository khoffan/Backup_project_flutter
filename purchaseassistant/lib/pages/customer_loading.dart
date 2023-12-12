import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/models/matchmodel.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';
import 'package:purchaseassistant/services/matching_services.dart';

class CustomerLoadingScreen extends StatefulWidget {
  CustomerLoadingScreen(
      {super.key, this.submitOrder, this.riderid, this.riderName});

  final bool? submitOrder;
  final String? riderid;
  final String? riderName;

  @override
  State<CustomerLoadingScreen> createState() => _CustomerLoadingScreenState();
}

class _CustomerLoadingScreenState extends State<CustomerLoadingScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  String riderid = "";
  String ridername = "";
  bool? riderSts;

  void connectChatScreen(BuildContext context) async {
    while (true) {
      if (riderSts == true && ridername != "" && riderid != "") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(reciveuid: riderid, name: ridername),
          ),
        );
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      uid = _auth.currentUser!.uid;
      riderSts = widget.submitOrder!;
      riderid = widget.riderid!;
      ridername = widget.riderName!;

      connectChatScreen(context);
    } else {
      // Handle the case where _auth.currentUser is null, perhaps redirect to login
      // or take appropriate action for your application.
      print("User not authenticated");
    }
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
