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
  bool? isLoading;
  bool? isMatch;
  bool valueFirst = false;
  bool valueSecond = false;
  bool valueThird = false;
  Map<String, dynamic> responseData = {};
  Map<String, dynamic> responseDatariders = {};
  late StreamSubscription<double> subscription;
  late StreamSubscription<Map<String, dynamic>> streamData;

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

  void sendData2api(String uid) async {
    String name = "";
    Timestamp datenow = Timestamp.now();
    Map<String, dynamic> profileData = {};
    String locate = "";
    // Check if uid is not empty or null

    try {
      if (uid != "") {
        profileData = await getProfileData(uid);
      }
      if (profileData.isNotEmpty) {
        name = profileData['name'];
      }
      locate = getLocateData();
      Map<String, dynamic> userData = <String, dynamic>{
        "id": uid,
        'name': name,
        "location": locate,
        "date": FormatDate.date(datenow),
      };

      await APIMatiching().setCustomerData(userData);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => LoadingCustomerScreen(
      //       riderid: uid,
      //     ),
      //   ),
      // );
      // DeliverHistory(cusid: cusid, riderid: riderid,);
    } catch (e) {
      print("Error connect: ${e}");
    }
  }

  void connectMatchingResult() {
    try {
      if (uid != "") {
        streamData = APIMatiching().getData(uid).listen(
          (Map<String, dynamic> snapshotData) {
            print(snapshotData["rider_status"]);
            if (snapshotData["rider_status"] == true && isLoading == false) {
              name = snapshotData["ridername"];
              reciveuid = snapshotData["riderid"];
              if ((name, reciveuid) != "") {
                setState(() {
                  isLoading = true;
                  isMatch = false;
                });
                APIMatiching().updateStatusChatCustomer(uid);
                APIMatiching().updateStatusCustomer(uid);
              }
              // Future.delayed(Duration(seconds: 30), () {
              //   _showAlertDelay();
              // });
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
    } on FirebaseAuthException catch (e) {
      print(e.message);
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

  getAmount(BuildContext context, String uid) {
    try {
      if (uid != "") {
        subscription = ServiceWallet().getTotalAmount(uid).listen(
          (double totalAmount) {
            if (totalAmount == 0.00) {
              Future.delayed(Duration(seconds: 1), () {
                alertNOtAmout(context);
              });
            }
            setState(() {
              amount = totalAmount;
            });
            print('Total Amount: $totalAmount');
          },
          onError: (dynamic error) {
            // Handle errors
            print('Error: $error');
          },
          onDone: () {
            // Handle when the stream is closed
            print('Stream is closed');
          },
        );
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
                  CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Colors.amber,
                    backgroundColor: Colors.white,
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
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
    Overlay.of(context).insert(entry);

    if (isLoading == true) {
      entry.remove();
    }
    Future.delayed(Duration(seconds: 5), () {
      entry.remove();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = false;
      isMatch = false;
    });
    uid = _auth.currentUser!.uid;
    getAmount(context, uid);
    connectMatchingResult();
    print("isLoading: $isLoading");
    print("isMatch: $isMatch");
  }

  @override
  void dispose() {
    super.dispose();
    streamData.cancel();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return showScreen(context);
  }

  Widget showScreen(BuildContext context) {
    return isLoading != true
        ? Scaffold(
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
                  )),
            ),
            body: _ShowContent(),
          )
        : ChatScreen(reciveuid: reciveuid, name: name);
  }

  Widget _ShowContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  onTap: () {
                    if (((valueFirst == true || valueSecond == true) &&
                            valueThird != true) &&
                        amount > 10.00) {
                      sendData2api(uid);
                      _overlayPopup();
                    } else {
                      String msgErr = "";
                      if (amount < 50.00) {
                        msgErr = "เงินในวอลเล็ตของคุณไม่เพียงพอ";
                      } else if ((valueFirst == false ||
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
                                  valueThird == true) &&
                              amount > 10.00) {
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
                            if (amount < 10.00) {
                              msgErr2 = "เงินในวอลเล็ตของคุณไม่เพียงพอ";
                            } else if (valueFirst == false ||
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
        //   children: [Text("${amount}")],
        // )
      ],
    );
  }
}

alertNOtAmout(BuildContext context) {
  return QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    title: 'เงินคงเหลือไม่เพียงพอ',
    text: "กรุณาเติมเงินก่อนทำรายการ",
    confirmBtnText: 'เติมเงิน',
    onConfirmBtnTap: () =>
        Navigator.pushReplacementNamed(context, AppRoute.wallet),
    confirmBtnColor: Colors.blue,
    cancelBtnText: 'ยกเลิก',
  );
}
