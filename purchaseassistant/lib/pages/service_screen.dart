import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_radio.dart';
import '../widgets/dropdown_location.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int _value = 1;
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
              // SizedBox(
              //     height: 10.0,
              //     child: TextButton(
              //       onPressed: () {
              //         Navigator.of(context).push(
              //           MaterialPageRoute(
              //             builder: (ctx) => const LoginScreen(),
              //           ),
              //         );
              //       },
              //       child: Text(
              //         "Login",
              //         style: TextStyle(
              //           color: themeError,
              //         ),
              //       ),
              //     )),
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
