import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:purchaseassistant/utils/constants.dart';

class OrderTrackers extends StatefulWidget {
  OrderTrackers({Key? key,  this.otherid}) : super(key: key);

  String? otherid;
  @override
  State<OrderTrackers> createState() => _OrderTrackersState();
}

class _OrderTrackersState extends State<OrderTrackers> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = "";
  String currid = "";
  late int checkState;
  List<int> showState = [1, 2, 3, 4, 5];
  int trackState = 0;
  Timestamp timeState = Timestamp.now();
  @override
  void initState() {
    checkState = 0;
    uid = _auth.currentUser!.uid;
    currid = widget.otherid ?? "";
    print(checkState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "ติดตามสถานะคำสั่งซื้อ",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              backgroundColor: themeBg,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        checkState += 1;
                        print(checkState);
                      });
                    },
                    child: Text(
                      'อัพเดทสถานะ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(20)),
                        backgroundColor: Colors.white38),
                  ),
                )
              ],
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add padding around the OrderTrackersZen widget for better presentation.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    // OrderTrackerZen is the main widget of the package which displays the order tracking information.
                    child: OrderTrackerZen(
                      text_primary_color: Colors.black,
                      success_color: Colors.cyan,
                      isShrinked: false,
                      screen_background_color: themeBg,
                      // Provide an array of TrackerData objects to display the order tracking information.
                      tracker_data: [
                        // TrackerData represents a single step in the order tracking process.

                        TrackerData(
                          title: "รอลูกค้าชำระเงินค่าธรรมเนียม",
                          date: "Sat, 8 Apr '22",
                          tracker_details: [
                            showState[0] <= checkState
                                ? TrackerDetails(
                                    title: "ลูกค้าชำระค่าธรรมสำเร็จ",
                                    datetime: "Sat, 8 Apr '22 - 17:17",
                                  )
                                : TrackerDetails(title: '', datetime: '')
                          ],
                        ),
                        // yet another TrackerData object
                        showState[1] <= checkState
                            ? TrackerData(
                                title: "กำลังดำเนินการตามข้อตกลง",
                                date: "Sat, 8 Apr '22",
                                tracker_details: [
                                  showState[2] <= checkState
                                      ? TrackerDetails(
                                          title: "ดำนเนินสำเร็จ",
                                          datetime: "Sat, 8 Apr '22 - 17:50",
                                        )
                                      : TrackerDetails(title: '', datetime: ''),
                                ],
                              )
                            : TrackerData(
                                title: '',
                                date: '',
                                tracker_details: [
                                    // TrackerDetails(title: '', datetime: '')
                                  ]),
                        showState[3] <= checkState
                            ? // And yet another TrackerData object
                            TrackerData(
                                title: "กำลังจัดส่ง",
                                date: "Sat,8 Apr '22",
                                tracker_details: [
                                  TrackerDetails(
                                    title:
                                        "กรุณาเตรียมเงินชำระค่าสินค้าให้พร้อม",
                                    datetime: "Sat, 8 Apr '22 - 17:51",
                                  ),
                                ],
                              )
                            : TrackerData(
                                title: '',
                                date: '',
                                tracker_details: [
                                    // TrackerDetails(title: '', datetime: '')
                                  ]),
                        showState[4] <= checkState
                            ? TrackerData(
                                title: "จัดส่งสำเร็จ",
                                date: "now",
                                tracker_details: [
                                  TrackerDetails(title: '', datetime: '')
                                ],
                              )
                            : TrackerData(
                                title: '',
                                date: '',
                                tracker_details: [
                                    // TrackerDetails(title: '', datetime: '')
                                  ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
