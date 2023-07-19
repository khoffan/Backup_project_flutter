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
            "service",
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
                  const Text("ฝากซื้อ  "),
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
                  const Text("รับฝากซื้อ"),
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
                  child: DropdownButtonApp(),
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        )
        // ],
        );
  }
}
