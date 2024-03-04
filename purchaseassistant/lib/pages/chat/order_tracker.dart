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
  bool setDefuilt = false;
  bool isCustomer = false;
  bool isEnable = false;
  bool isRider = false;
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
  }

  Future<void> checkCustomer() async {
    if (uid == cusid) {
      setState(() {
        isCustomer = !isCustomer;
        isRider = false;
      });

      await ChatServices().setTrackingState(chatroomid, isCustomer, isRider);
    } else {
      await ChatServices().setTrackingState(chatroomid, isCustomer, isRider);
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

  Future<void> setDefuiltData() async {
    if (uid == riderid) {
      setState(() {
        setDefuilt = !setDefuilt;
        isCustomer = !isCustomer;
        isRider = !isRider;
        isCustomerClicked = !isCustomerClicked;
      });

      await ChatServices().setDefulttracking(chatroomid, isCustomer, isRider);
    }
  }

  @override
  void initState() {
    super.initState();
    checkState = 0;
    uid = _auth.currentUser!.uid;
    chatroomid = widget.chatroomid ?? '';
    getrideridfromChatroom();
    checkCustomer();
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
    print("setDefuilt: $setDefuilt");
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
      future: setDefuilt != true
          ? checkCustomer()
          : ChatServices().setDefulttracking(chatroomid, isCustomer, isRider),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  'กำลังอัพเดตข้อมูล...',
                  style:
                      TextStyle(fontSize: 16, decoration: TextDecoration.none),
                ),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: ChatServices().getTrackingState(chatroomid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          'อัพเดตสำเร็จ',
                          style: TextStyle(
                              fontSize: 16, decoration: TextDecoration.none),
                        ),
                      ],
                    ));
              }
              if (!snapshot.hasData) {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
              final Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              bool customerCheck = data["isCustomer"];
              bool riderCheck = data["isRider"];

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
                        riderCheck == false)
                      buildButton(uid == cusid ? customerCheck : false, () {
                        setState(() {
                          isCustomer = !isCustomer;
                          isRider = !isRider;
                          isEnable = true;
                          state = checkState + 1;
                          isCustomerClicked = !isCustomerClicked;

                          print("isParted: $isParted");
                          print("customerCheck: $customerCheck");
                          print("isRider: $isRider");
                          print("isCustomerClicked: $isCustomerClicked");
                          ChatServices().updateTRackingState(
                              chatroomid, state, isCustomer, isRider);
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
                          uid == riderid && state < 5 ? riderCheck : false, () {
                        setState(() {
                          state += 1;
                          if (state % 6 == 0) {
                            state = 0;
                          }
                          isCustomer = false;
                          isRider = true;
                          ChatServices().updateTRackingState(
                              chatroomid, state, isCustomer, isRider);
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
                      if (riderCheck == true && endPartedCheck == true)
                        ElevatedButton(
                          onPressed: () {
                            setDefuiltData();
                          },
                          child: Text("ส่งสินค้าสำเร็จ"),
                        )
                      else
                        ElevatedButton(
                            onPressed: null, child: Text("ส่งสินค้าสำเร็จ"))
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
