import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/service_screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Container(
        child: ElevatedButton(
          onPressed: () {
            _showdialogAutoNavigate();
          },
          child: Text("Test"),
        ),
      ),
    ));
  }

  void _showdialogAutoNavigate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Test"),
          content: Text("Test"),
        );
      },
    );

    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ServiceScreen()));
    });
  }
}
