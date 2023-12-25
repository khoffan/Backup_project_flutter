import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:purchaseassistant/Provider/deliverDataProvider.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';
import 'package:purchaseassistant/pages/testPage.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/utils/formatDate.dart';
import '../models/matchmodel.dart';
import '../services/profile_services.dart';
import '../utils/constants.dart';

import 'customer_loading.dart';
import 'posted/deliverer_history.dart';
import 'posted/deliverer_screen.dart';

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
  double amount = 50.00;
  Map<String, dynamic> responseData = {};
  Map<String, dynamic> responseDatariders = {};

  bool valueFirst = false;
  bool valueSecond = false;
  bool valueThird = false;
  // 'ศูนย์อาหารโรงช้าง',
  // 'ภายในเขตหอพักนักศึกษา',
  // 'ภายในมหาวิทยาลัยสงขลานครินทร์',
  // 'ตลาดศรีตรัง',
  // 'โลตัส สาขา ม.อ.',
  // 'สถานีขนส่ง หาดใหญ่',
  // 'เซนทรัลเฟตติวัลหาดใหญ่'
  String getLocationData(String title) {
    if (title != "") {
      return title;
    }
    return "";
  }

  bool? submituid1(BuildContext context, String curcusid) {
    try {
      // List<Map<String, dynamic>> allData =
      //     await APIMatiching().getMatchingresult();
      // for (Map<String, dynamic> data in allData) {
      //   ;
      // }
      if (uid == curcusid) {
        return true;
      }
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  void sendData2api(String uid, String locate) async {
    try {
      String name = "";
      Timestamp datenow = Timestamp.now();
      if (uid != "") {
        DocumentSnapshot snapshot =
            await _firestore.collection("Post").doc(uid).get();
        final datasnap = snapshot.data()! as Map<String, dynamic>;
        name = datasnap["name"] ?? '';
      }
      if (uid != "" && locate != "") {
        Map<String, dynamic> userData = {
          "id": uid,
          'name': name,
          "location": locate,
          "date": FormatDate(datenow)
        };

        await APIMatiching().setCustomerData(userData);
        

        // DeliverHistory(cusid: cusid,riderid: riderid,);
      }
    } catch (e) {
      // Handle errors
      print('Error: $e, Error: uid or locate is null');
    }
  }

  void getRiderlist() async {
    try {
      Map<String, dynamic> datariders =
          await APIMatiching().getRiderlist("riderlist");

      if (datariders != {}) {
        responseDatariders = await APIMatiching().setResponse(datariders);
        print("riders-list: ${responseDatariders["riders"]}");
        String ridersdata = json.encode(responseDatariders["riders"]);
        List<dynamic> jsonlist = json.decode(ridersdata);
        Riderlist ridersList = Riderlist.fromJson(jsonlist);

        for (RiderModel rider in ridersList.riders) {
          print('Name: ${rider.name}');
          print('Location: ${rider.location}');
          print('Date: ${rider.date}');
          print('ID: ${rider.id}');
          print('Status User: ${rider.statususer}');
          print('------------');
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(
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
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500),
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
                              ? (valueFirst
                                  ? valueThird = true
                                  : print('not all'))
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
                )),
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
                          sendData2api(uid, locateData);
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

                          locateData = getLocationData(title);
                        }
                        if (valueSecond == true &&
                            valueThird == false &&
                            valueFirst == false) {
                          String title = "หอพัก - โลตัสหน้า ม.อ.";
                          ServiceDeliver().updateStatus(false, uid, title);

                          locateData = getLocationData(title);
                        }
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
                                "ลูกค้า",
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return DeliverHistory();
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
                              }
                              if (valueSecond == true && valueThird == false) {
                                String title = "หอพัก - โลตัสหน้า ม.อ.";
                                ServiceDeliver().updateStatus(true, uid, title);
                                ServiceDeliver().updateWorking(uid, true);
                                ProfileService().updateRole(uid, "rider");
                              }
                              if (valueThird == true) {
                                String title = "รับทุกงาน";
                                ServiceDeliver().updateStatus(true, uid, title);
                                ServiceDeliver().updateWorking(uid, true);
                                ProfileService().updateRole(uid, "rider");
                              }
                              // ServiceDeliver().setStatus(true, uid, "");

                              print("save status success");
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
            Spacer(),
            
          ],
        )
        // ],
        );
  }
}
