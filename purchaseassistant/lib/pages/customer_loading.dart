import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/models/matchmodel.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';
import 'package:purchaseassistant/services/matching_services.dart';

class CustomerLoadingScreen extends StatefulWidget {
  CustomerLoadingScreen({super.key, this.currid, this.recivefId});

  final String? currid;
  final String? recivefId;

  @override
  State<CustomerLoadingScreen> createState() => _CustomerLoadingScreenState();
}

class _CustomerLoadingScreenState extends State<CustomerLoadingScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  String currid = "";
  String recivedId = "";

  void connectMatchingResult(BuildContext context) async {
    if ((uid, currid, recivedId) != "") {
      
    }
  }

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      uid = _auth.currentUser!.uid;
      currid = widget.currid ?? "";
      recivedId = widget.recivefId ?? '';

      connectMatchingResult(context);
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
