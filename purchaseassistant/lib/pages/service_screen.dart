import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';

import 'package:purchaseassistant/routes/routes.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/services/wallet_service.dart';
import 'package:purchaseassistant/utils/formatDate.dart';
import 'package:quickalert/quickalert.dart';
import '../models/matchmodel.dart';
import '../services/profile_services.dart';
import '../utils/constants.dart';

import 'customer_loading.dart';
import 'posted/deliverer_history.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  String locateData = "";
  String cusid = "";
  String riderid = "";
  DeliveryData deliData = DeliveryData();
  double amount = 0.00;
  String currid = "";
  String reciveuid = "";
  String name = "";
  String statusChat = "";
  bool valueFirst = false;
  bool valueSecond = false;
  bool valueThird = false;
  bool hasNavigate = false;
  bool cusstatuslocal = true;
  Map<String, dynamic> responseData = {};
  Map<String, dynamic> responseDatariders = {};
  late StreamSubscription<Map<String, dynamic>> streamData;

  // Declare a stream controller

  void setLocationData(String title) {
    if (title != "") {
      setState(() {
        locateData = title;
      });
    }
  }

  String getLocateData() {
    return locateData;
  }

  Future<Map<String, dynamic>> getProfileData(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("Profile").doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        // Handle the case when the document doesn't exist
        print('Error: Document does not exist for uid: $uid');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
    return {};
  }

  Future<void> sendData2api(String userid) async {
    if (!mounted) {
      return; // Avoid processing if the widget is already disposed
    }

    String name = "";
    Timestamp datenow = Timestamp.now();
    Map<String, dynamic> profileData = {};
    String locate = "";

    try {
      if (userid != "") {
        profileData = await getProfileData(userid);
      }

      if (profileData.isNotEmpty) {
        name = profileData['name'];
        locate = getLocateData();
        Map<String, dynamic> userData = <String, dynamic>{
          "id": userid,
          'name': name,
          "location": locate,
          "date": FormatDate.date(datenow),
        };

        await APIMatiching().setCustomerData(userData);
      }
    } catch (e) {
      if (mounted) {
        // Handle errors only if the widget is still mounted
        print('Error: $e');
      }
    }
  }

  bool checkData() {
    // Add your custom logic to check if data is valid
    return name.isNotEmpty && reciveuid.isNotEmpty;
  }

  void navigateToChatScreen() {
    // set timer 2 secound
    Timer(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(reciveuid: reciveuid, name: name),
          ),
          ModalRoute.withName(AppRoute.widget_navigation));
    });
  }

  Future<void> connectMatchingResult() async {
    try {
      if (uid != "") {
        streamData = APIMatiching().getData(uid).listen(
          (Map<String, dynamic> snapshotData) async {
            print(snapshotData["rider_status"]);
            bool cusStatus = snapshotData["cusStatus"];
            if (snapshotData["rider_status"] == true && hasNavigate == false) {
              setState(() {
                hasNavigate = true;
                cusstatuslocal = cusStatus;
              });
              print(cusstatuslocal);
              name = snapshotData["ridername"];
              reciveuid = snapshotData["riderid"];

              if ((name, reciveuid) != "" && mounted) {
                await APIMatiching().updateStatusChatCustomer(uid);
                await APIMatiching().updateStatusCustomer(uid, null);
              }
              if (hasNavigate == true && checkData() && cusStatus == true) {
                navigateToChatScreen();
              }
            } else {
              setState(() {
                hasNavigate = false;
              });
            }
          },
          onError: (dynamic error) {
            print("Error: ${error}");
          },
          onDone: () {
            print("Stream is closed");
          },
        );
      } else {
        print("Document not updated");
      }
    } catch (e) {
      if (mounted) {
        throw e.toString();
      }
    }
  }

  void delCustomertoRider(String uid) async {
    try {
      if (uid != "") {
        APIMatiching().delCustomertoRider(uid);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  void _overlayPopup() {
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).size.height / 8,
          left: MediaQuery.of(context).size.width / 3,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.black12,
            ),
            child: Row(
              children: [
                // LinearProgressIndicator(),
                Text(
                  "...",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'กำลังจับคู่',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(entry);
    if (cusstatuslocal == false) {
      entry.remove();
    }
    Future.delayed(Duration(seconds: 10), () {
      entry.remove();
    });
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    setState(() {
      hasNavigate = false;
    });
    if (mounted) {
      connectMatchingResult();
    }
  }

  @override
  void dispose() {
    super.dispose();
    streamData.cancel();
  }

  int numbercheck = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: themeBg,
        title: const Text(
          "เลือกบริการ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: _ShowContent(),
    );
  }

  Widget _ShowContent() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              const Row(
                children: [
                  Text(
                    'เลือกขอบเขตสถานที่ใช้บริการ',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              CheckboxListTile(
                secondary: const Icon(Icons.area_chart),
                title: const Text('หอพัก - ภายในหมาวิทยาลัย'),
                subtitle: Text('ค่าบริการขั้นต่ำ 10 บาท'),
                value: this.valueFirst,
                onChanged: (bool? value) {
                  setState(() {
                    this.valueFirst = value!;
                    value
                        ? (this.valueSecond
                            ? valueThird = true
                            : print('not all'))
                        : valueThird = false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                secondary: const Icon(Icons.alarm),
                title: const Text('หอพัก - โลตัสหน้า ม.อ.'),
                subtitle: Text('ค่าบริการขั้นต่ำ 15 บาท'),
                value: valueSecond,
                onChanged: (bool? value) {
                  setState(() {
                    valueSecond = value!;
                    value
                        ? (valueFirst ? valueThird = true : print('not all'))
                        : valueThird = false;
                  });
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                secondary: const Icon(Icons.alarm),
                title: const Text('รับงานทุกพื้นที่'),
                subtitle: Text(
                  '***เฉพาะผู้ส่งสินค้า',
                  style: TextStyle(color: Colors.red),
                ),
                value: this.valueThird,
                onChanged: (bool? value) {
                  setState(() {
                    this.valueThird = value!;
                    if (this.valueThird) {
                      this.valueFirst = value;
                      this.valueSecond = value;
                    } else {
                      this.valueFirst = value;
                      this.valueSecond = value;
                    }
                  });
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 170,
                height: 100,
                child: InkWell(
                  onTap: () async {
                    if (((valueFirst == true || valueSecond == true) &&
                        valueThird != true)) {
                      _overlayPopup();
                      sendData2api(uid);
                    } else {
                      String msgErr = "";
                      if ((valueFirst == false ||
                          valueSecond == false ||
                          valueThird == false)) {
                        msgErr = "กรุณาเลือกสถานที่ที่ต้องการใช้บริการ";
                      } else if (valueThird == true &&
                          valueFirst == true &&
                          valueSecond == true) {
                        msgErr =
                            "ไม่สามารถเลือกรายการนี้ได้ กรุณาเลือกสถานที่ใหม่";
                      }
                      Fluttertoast.showToast(msg: msgErr);
                    }
                    print(amount);
                    if (valueFirst == true &&
                        valueThird == false &&
                        valueSecond == false) {
                      String title = "หอพัก - ภายในหมาวิทยาลัย";
                      ServiceDeliver().updateStatus(false, uid, title);
                      // ServiceDeliver().setWorking(uid, false);
                      setLocationData(title);
                    }
                    if (valueSecond == true &&
                        valueThird == false &&
                        valueFirst == false) {
                      String title = "หอพัก - โลตัสหน้า ม.อ.";
                      ServiceDeliver().updateStatus(false, uid, title);
                      // ServiceDeliver().setWorking(uid, false);
                      setLocationData(title);
                    }
                    // getRiderlist();
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Icon(
                              Icons.face,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Text(
                            "ฝากซื้อ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            SizedBox(
                width: 170,
                height: 100,
                child: InkWell(
                  onTap: () {
                    print("Rider");
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          if ((valueFirst == true ||
                              valueSecond == true ||
                              valueThird == true)) {
                            delCustomertoRider(uid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return DeliverHistory(
                                  riderLocate: locateData,
                                );
                              }),
                            );
                          } else {
                            String msgErr2 = "";
                            if (valueFirst == false ||
                                valueSecond == false ||
                                valueThird == false) {
                              msgErr2 = "กรุณาเลือกสถานที่ที่ต้องการรับส่ง";
                            }
                            Fluttertoast.showToast(msg: msgErr2);
                          }
                          print(amount);
                          if (valueFirst == true && valueThird == false) {
                            String title = "หอพัก - ภายในหมาวิทยาลัย";
                            ServiceDeliver().updateStatus(true, uid, title);
                            ServiceDeliver().updateWorking(uid, true);
                            ProfileService().updateRole(uid, "rider");
                            setLocationData(title);
                          }
                          if (valueSecond == true && valueThird == false) {
                            String title = "หอพัก - โลตัสหน้า ม.อ.";
                            ServiceDeliver().updateStatus(true, uid, title);
                            ServiceDeliver().updateWorking(uid, true);
                            ProfileService().updateRole(uid, "rider");
                            setLocationData(title);
                          }
                          if (valueThird == true) {
                            String title = "รับทุกงาน";
                            ServiceDeliver().updateStatus(true, uid, title);
                            ServiceDeliver().updateWorking(uid, true);
                            ProfileService().updateRole(uid, "rider");
                            setLocationData(title);
                          }
                          // ServiceDeliver().setStatus(true, uid, "");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: const Icon(
                                Icons.electric_moped,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Text(
                              "ผู้ส่งสินค้า",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
        // Spacer(),
        // Column(
        //   children: [
        //     ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             numbercheck += 1;
        //           });
        //           print("numbercheck before refresh: $numbercheck");
        //         },
        //         child: Text("click"))
        //   ],
        // )
      ],
    );
  }
}
