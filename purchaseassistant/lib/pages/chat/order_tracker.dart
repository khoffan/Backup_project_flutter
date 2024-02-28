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
  bool isCollection = false;
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

  Future<void> getrideridfromChatroom() async {
    String rider = await ChatServices().getRiderChatroomid(chatroomid);
    String cus = await ChatServices().getCustomerChatroomid(chatroomid);
    setState(() {
      riderid = rider;
      cusid = cus;
    });
    if (mounted) {
      checkCustomer(cusid);
    }
  }

  Future<void> checkCustomer(String customerid) async {
    if (uid == cusid) {
      setState(() {
        isCustomer = true;
        isRider = false;
      });

      await ChatServices()
          .setTrackingState(chatroomid, isCustomer ?? false, isRider ?? false);
    }
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> initializeData() async {
    // Set data before using StreamBuilder
    await ChatServices().checkCollectionTracking(chatroomid).then((value) {
      setState(() {
        isCollection = value;
      });
      if (isCollection == false) {
        getrideridfromChatroom();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkState = 0;
    uid = _auth.currentUser!.uid;
    chatroomid = widget.chatroomid ?? '';
    getrideridfromChatroom();
    // ChatServices().checkCollectionTracking(chatroomid).then((value) {
    //   setState(() {
    //     isCollection = value;
    //   });
    //   if (isCollection) {
    //     print("collection is exists");
    //   } else {
    //     getrideridfromChatroom();
    //   }
    // });
    print("isCollection: $isCollection");

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
    return FutureBuilder(
      future: ChatServices()
          .setTrackingState(chatroomid, isCustomer ?? false, isRider ?? false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: ChatServices().getTrackingState(chatroomid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: Text("No information"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>;
              if (data == null) {
                getrideridfromChatroom();
              }

              bool? customerCheck = data?["isCustomer"];
              bool? riderCheck = data?["isRider"];

              print("customerCheck: $customerCheck");
              print("riderCheck: $riderCheck");
              print("isCustomerClicked: $isCustomerClicked");
              int state = data?["trackState"] ?? 0;
              bool firstPartedCheck = data?["isParted"] ?? false;
              bool secoundPartedCheck = data?["isPartedscound"] ?? false;
              bool thridPartedCheck = data?["isPartedthird"] ?? false;
              bool forthPartedCheck = data?["isPartedforth"] ?? false;
              bool endPartedCheck = data?["isPartedend"] ?? false;
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
                          isCustomerClicked == true
                              ? false
                              : riderCheck ?? false, () {
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
                        eventCard: Text("ยืนยันคำสั่งซื้อโดยลูกค้า"),
                      ),
                      MyTimelineTile(
                        isFirst: false,
                        isLast: false,
                        isPart: secoundPartedCheck,
                        eventCard: Text("ไรเดอร์กำลังดำเนินตามคำสั่งซื้อ"),
                      ),
                      MyTimelineTile(
                        isFirst: false,
                        isLast: false,
                        isPart: thridPartedCheck,
                        eventCard: Text("ซื้อสินค้าสำเร็จ"),
                      ),
                      MyTimelineTile(
                        isFirst: false,
                        isLast: false,
                        isPart: forthPartedCheck,
                        eventCard: Text("ไรเดอร์กำลังนำส่งสินค้าไปยังผู้รับ"),
                      ),
                      MyTimelineTile(
                        isFirst: false,
                        isLast: true,
                        isPart: endPartedCheck,
                        eventCard: Text("รอส่งสินค้า"),
                      ),
                      ElevatedButton(
                          onPressed: riderCheck ?? false ? () {} : null,
                          child: Text("ส่งสินค้าสำเร็จ"))
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
