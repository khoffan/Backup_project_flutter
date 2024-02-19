import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/services/chat_services.dart';
import 'package:purchaseassistant/utils/constants.dart';
import 'package:purchaseassistant/utils/my_timeline_tile.dart';

class OderTrackerScreen extends StatefulWidget {
  OderTrackerScreen({Key? key, this.chatroomid}) : super(key: key);

  String? chatroomid;
  @override
  State<OderTrackerScreen> createState() => _OderTrackerScreenState();
}

class _OderTrackerScreenState extends State<OderTrackerScreen> {
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
  bool isPartedscound = false;
  bool isPartedthird = false;
  bool isPartedforth = false;
  bool isPartedend = false;
  bool isCustomerClicked = false;
  bool dataHasBeenSet = false;
  late int checkState;

  void getrideridfromChatroom() async {
    String riderid = await ChatServices().getRiderChatroomid(chatroomid);
    String cusid = await ChatServices().getCustomerChatroomid(chatroomid);
    setState(() {
      riderid = riderid;
      cusid = cusid;
    });
    if (dataHasBeenSet != true && mounted) {
      checkCustomer(cusid);
    }
  }

  void checkCustomer(String customerid) async {
    if (uid == customerid && !dataHasBeenSet) {
      setState(() {
        isCustomer = true;
        isRider = false;
      });

      await ChatServices()
          .setTrackingState(chatroomid, isCustomer ?? false, isRider ?? false);
      dataHasBeenSet = true;
    }
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    checkState = 0;
    uid = _auth.currentUser!.uid;
    chatroomid = widget.chatroomid ?? '';

    getrideridfromChatroom();
    print("chatroomid: $chatroomid");
    print(uid);

    print(riderid);
    print(cusid);
  }

  @override
  void dispose() {
    // Reset the flag when the widget is disposed (e.g., when navigating back)
    dataHasBeenSet = true;
    super.dispose();
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
          print("isCustomerClicked: $isCustomerClicked");
          int state = data["trackState"];
          bool firstPartedCheck = data["isParted"] ?? false;
          bool secoundPartedCheck = data["isPartedscound"] ?? false;
          bool thridPartedCheck = data["isPartedthird"] ?? false;
          bool forthPartedCheck = data["isPartedforth"] ?? false;
          bool endPartedCheck = data["isPartedend"] ?? false;
          print("state: $state");
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
                      isCustomer = false;
                      isRider = true;
                      isEnable = true;
                      state = checkState + 1;
                      isCustomerClicked = true;

                      print("isParted: $isParted");
                      print("customerCheck: $customerCheck");
                      print("isRider: $isRider");
                      print("isCustomerClicked: $isCustomerClicked");
                      ChatServices().updateTRackingState(chatroomid, state,
                          isCustomer ?? false, isRider ?? false);
                      if (state == 1) {
                        isParted = true;
                      }
                      ChatServices().updateStateValue(
                        chatroomid,
                        isParted,
                        false,
                        false,
                        false,
                        false,
                      );
                    });
                  })
                else
                  buildButton(
                      isCustomerClicked == true ? false : riderCheck ?? false,
                      () {
                    setState(() {
                      state += 1;
                      if (state % 6 == 0) {
                        state = 0;
                      }
                      isCustomer = false;
                      isRider = true;
                      ChatServices().updateTRackingState(chatroomid, state,
                          isCustomer ?? false, isRider ?? false);
                      switch (state) {
                        case 2:
                          isPartedscound = true;
                          break;
                        case 3:
                          isPartedthird = true;
                          break;
                        case 4:
                          isPartedforth = true;
                          break;
                        case 5:
                          isPartedend = true;
                          break;
                        default:
                          break;
                      }
                      ChatServices().updateStateValue(
                        chatroomid,
                        true,
                        isPartedscound,
                        isPartedthird,
                        isPartedforth,
                        isPartedend,
                      );
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
                    isPart: firstPartedCheck,
                    eventCard: Text("จ่ายเงินสำเร็จ"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: false,
                    isPart: secoundPartedCheck,
                    eventCard: Text("order data 2"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: false,
                    isPart: thridPartedCheck,
                    eventCard: Text("order data 2"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: false,
                    isPart: forthPartedCheck,
                    eventCard: Text("order data 2"),
                  ),
                  MyTimelineTile(
                    isFirst: false,
                    isLast: true,
                    isPart: endPartedCheck,
                    eventCard: Text("order data 3"),
                  ),
                  endPartedCheck == true
                      ? ElevatedButton(
                          onPressed: () {}, child: Text("เสร็จสิ้น"))
                      : Container(),
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
