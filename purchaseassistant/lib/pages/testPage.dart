import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 15,
          ),
          const Text("ระบบกำลังจับคู่หาผู้ขับให้กับคุณ"),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ยกเลิก'))
        ],
      )),
    );
  }
}
