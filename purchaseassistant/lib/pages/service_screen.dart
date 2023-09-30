import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/testPage.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import '../utils/constants.dart';

import 'deliverer_history.dart';
import 'deliverer_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";

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
  void sendLocationRider(String title) {
    print(title);
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid ?? '';
    print(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeBg,
          title: const Text(
            "Service Selection",
            style: TextStyle(color: Colors.black),
          ),
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
                      value: this.valueSecond,
                      onChanged: (bool? value) {
                        setState(() {
                          this.valueSecond = value!;
                          value
                              ? (this.valueFirst
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => TestPage()));
                        print("Custommer");
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const DeliverHistory();
                                }),
                              );
                              ServiceDeliver().setStatus(true, uid);
                              ServiceDeliver().updateStatus(true, uid);
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
            // SizedBox(
            //   height: 120.0,
            //   child: Center(
            //     child: TextButton(
            //       onPressed: () {
            //         if (valueFirst == true) {
            //           String title = "หอพัก - ภายในหมาวิทยาลัย";
            //           sendLocationRider(title);
            //         }
            //         if (valueSecond == true) {
            //           String title = "หอพัก - โลตัสหน้า ม.อ.";
            //           sendLocationRider(title);
            //         }
            //         if (valueThird == true &&
            //             valueSecond == true &&
            //             valueFirst == true) {
            //           String title = "รับทุกงาน";
            //           sendLocationRider(title);
            //         }
            //       },
            //       child: Text(
            //         "     Matching    ",
            //         style: TextStyle(fontSize: 20, color: Colors.black),
            //       ),
            //       style: TextButton.styleFrom(
            //           backgroundColor: Colors.purple[100],
            //           shape: const BeveledRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(5)))),
            //     ),
            //   ),
            // )
          ],
        )
        // ],
        );
  }
}
