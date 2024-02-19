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
  bool? isCustomer;
  bool isEnable = false;
  bool? isRider;
  bool isParted = false;
  bool isCustomerClicked = false;
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

  void checkCustomer(String customerid) async {
    if (uid == customerid) {
      setState(() {
        isCustomer = true;
        isRider = false;
      });

      await ChatServices()
          .setTrackingState(chatroomid, isCustomer ?? false, isRider ?? false);
    }
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    checkState = 0;
    uid = _auth.currentUser!.uid;
    chatroomid = widget.chatroomid ?? '';

    getrideridfromChatroom(checkCustomer);
    print("chatroomid: $chatroomid");
    print(uid);

    print(riderid);
    print(cusid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ChatServices().getTrackingState(chatroomid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("No information"),
            );
          }

          final Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          bool? customerCheck = data["isCustomer"];
          bool? riderCheck = data["isRider"];

          print("customerCheck: $customerCheck");
          print("riderCheck: $riderCheck");
          int state = data["trackState"];
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
                if (customerCheck == true &&
                    !isCustomerClicked &&
                    riderCheck == false &&
                    isRider == false)
                  buildButton(
                      isCustomerClicked == false
                          ? customerCheck ?? false
                          : false, () {
                    setState(() {
                      isParted = !isParted;
                      isCustomer = false;
                      isRider = true;
                      isEnable = true;
                      checkState = 1;
                      isCustomerClicked = true;

                      print("customerCheck: $customerCheck");
                      print("isRider: $isRider");
                      print("isCustomerClicked: $isCustomerClicked");
                      ChatServices().updateTRackingState(chatroomid, checkState,
                          isCustomer ?? false, isRider ?? false);
                    });
                  })
                else
                  buildButton(
                      isCustomerClicked == true ? false : riderCheck ?? false,
                      () {
                    setState(() {
                      isParted = !isParted;
                      // isCustomer = false;
                      // isRider = true;
                      // isEnable = true;
                      // checkState = 1;

                      // print("customerCheck: $customerCheck");
                      // print("isRider: $isRider");
                      // print(isEnable);
                      // ChatServices().updateTRackingState(chatroomid, checkState,
                      //     isCustomer ?? false, isRider ?? false);
                    });
                  })
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
                    isPart: isParted,
                    eventCard: Text("จ่ายเงินสำเร็จ"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: false,
                    isPart: isParted,
                    eventCard: Text("order data 2"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: false,
                    isPart: isParted,
                    eventCard: Text("order data 2"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: false,
                    isPart: isParted,
                    eventCard: Text("order data 2"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: true,
                    isPart: isParted,
                    eventCard: Text("order data 3"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildButton(bool isEnable, VoidCallback onpressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ElevatedButton(
        onPressed: isEnable ? onpressed : null,
        child: Text("เพิ่มสถานะ  "),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.green[800],
          backgroundColor: Colors.green[200],
        ),
      ),
    );
  }
}
