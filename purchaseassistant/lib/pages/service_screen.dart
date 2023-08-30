import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/deliverer_screen.dart';
import 'package:purchaseassistant/utils/delivers_services.dart';
import '../utils/constants.dart';
import '../widgets/custom_radio.dart';
import '../widgets/dropdown_location.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";

  int _value = 1;

  @override
  void InitState(){
    super.initState();
    uid = _auth.currentUser?.uid ?? '';
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
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40.0,
                child: Text(
                  "เลือกบริการ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
                child: Row(children: [
                  const Text("ลูกค้า  "),
                  const SizedBox(
                    width: 40.0,
                  ),
                  CustomRadio(
                    value: 1,
                    groupValue: _value,
                    onChanged: (int? value) {
                      setState(() {
                        _value = value!;
                      });
                    },
                  ),
                ]),
              ),
              SizedBox(
                height: 40.0,
                child: Row(children: [
                  const Text("ผู้ส่งสินค้า"),
                  const SizedBox(
                    width: 30.0,
                  ),
                  CustomRadio(
                    value: 2,
                    groupValue: _value,
                    onChanged: (int? value) {
                      setState(() {
                        _value = value!;
                      });
                    },
                  ),
                ]),
              ),
              // const Divider(
              //   height: 1.0,
              //   thickness: 1,
              //   color: Colors.black54,
              // ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 40.0,
                child: Text(
                  "เลือกสถานที่",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 40.0,
                child: Card(
                  child: DropdownLocation(),
                  color: Colors.white,
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
                              onPressed: () async {
                                await ServiceDeliver().setStatus(true, uid);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return DelivererScreen();
                                  }),
                                );
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
              SizedBox(
                height: 120.0,
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "     Matching    ",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                  ),
                ),
              )
            ],
          ),
        )
        // ],
        );
  }
}
