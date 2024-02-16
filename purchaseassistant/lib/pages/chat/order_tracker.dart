import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String riderid = "";
  String cusid = "";
  String chatroomid = "";
  bool isCustomer = false;
  bool isRider = false;
  late int checkState;
  List<int> showState = [1, 2, 3, 4, 5];
  int trackState = 0;
  Timestamp timeState = Timestamp.now();
  Color c1 = Colors.red;

  void getrideridfromChatroom(Function checkCustomer) async {
    String riderid = await ChatServices().getRiderChatroomid(chatroomid);
    String cusid = await ChatServices().getCustomerChatroomid(chatroomid);
    print(riderid);
    print(cusid);
    setState(() {
      riderid = riderid;
      cusid = cusid;
    });
    print(riderid);
    print(cusid);
    checkCustomer(cusid);
  }

  void checkCustomer(String customerid) {
    if (uid == customerid) {
      setState(() {
        isCustomer = true;
        isRider = false;
      });
      print("isCustomer: $isCustomer");
      print("isRider: $isRider");
    } else {
      setState(() {
        isRider = true;
        isCustomer = false;
      });
      print("isCustomer: $isCustomer");
      print("isRider: $isRider");
    }
  }

  @override
  void initState() {
    super.initState();
    checkState = 0;
    uid = _auth.currentUser!.uid;
    chatroomid = widget.chatroomid ?? '';
    ChatServices().setTrackingState(chatroomid);
    getrideridfromChatroom(checkCustomer);
    print("chatroomid: $chatroomid");
    print(uid);

    print(riderid);
    print(cusid);
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
          isCustomer == true
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("เพิ่มสถานะ  "),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.green[800],
                      backgroundColor: Colors.green[200],
                    ),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: null,
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
