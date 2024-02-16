import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:purchaseassistant/services/chat_services.dart';
import 'package:purchaseassistant/utils/constants.dart';
import 'package:purchaseassistant/utils/my_timeline_tile.dart';

class OrderTrackers extends StatefulWidget {
  OrderTrackers({Key? key, this.chatroomid}) : super(key: key);

  String? chatroomid;
  @override
  State<OrderTrackers> createState() => _OrderTrackersState();
}

class _OrderTrackersState extends State<OrderTrackers> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = "";
  String currid = "";
  String chatroomid = "";
  late int checkState;
  List<int> showState = [1, 2, 3, 4, 5];
  int trackState = 0;
  Timestamp timeState = Timestamp.now();
  Color c1 = Colors.red;

  @override
  void initState() {
    checkState = 0;
    uid = _auth.currentUser!.uid;
    chatroomid = widget.chatroomid ?? '';
    ChatServices().setTrackingState(chatroomid);
    print("chatroomid: $chatroomid");
    print(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ติดตามการสั่งซื้อ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: themeBg,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("เพิ่มสถานะ  "),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.green[800],
                backgroundColor: Colors.green[200],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "ติดตามการสั่งซื้อ",
                style: TextStyle(fontSize: 24),
              ),
            ),
            MyTimelineTile(
              isFirst: true,
              isLast: false,
              isPart: true,
              eventCard: Text("order data"),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: false,
              isPart: true,
              eventCard: Text("order data 2"),
            ),
            MyTimelineTile(
              isFirst: false,
              isLast: true,
              isPart: false,
              eventCard: Text("order data 3"),
            ),
          ],
        ),
      ),
    );
  }
}
