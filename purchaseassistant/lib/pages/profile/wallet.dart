import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/utils/constants.dart';
import 'package:quickalert/models/quickalert_type.dart';

import 'dart:developer' as developer;

import 'package:quickalert/widgets/quickalert_dialog.dart';

class WalletScreenApp extends StatefulWidget {
  const WalletScreenApp({super.key});

  @override
  State<WalletScreenApp> createState() => _WalletScreenAppState();
}

class _WalletScreenAppState extends State<WalletScreenApp> {
  late TextEditingController amountController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  int amount = 0;
  var totalAmount;
  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wallet',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: themeBg,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                color: themeBg.withRed(200),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 90, bottom: 40, left: 50, right: 50),
                      child: Center(
                        child: StreamBuilder(
                            stream: firestore
                                .collection('Profile')
                                .doc(auth.currentUser!.uid)
                                .collection("transaction")
                                .orderBy("totalAmount", descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text("${snapshot.error}"),
                                );
                              } else if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                QueryDocumentSnapshot doc =
                                    snapshot.data!.docs.first;
                                Map<String, dynamic> data =
                                    doc.data() as Map<String, dynamic>;
                                totalAmount = data["totalAmount"] ?? 0;
                                return Text(
                                  'ยอดเงินคงเหลือ ${data["totalAmount"]} บาท',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                );
                              }
                              totalAmount = 0.00;
                              debugPrint(
                                  'ccccccc ->>>> ${totalAmount.runtimeType}');
                              return Container(
                                child: Text(
                                  'ยอดเงินคงเหลือ 0.00 บาท',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }),
                      ),
                    ),
                    Center(
                        child: GestureDetector(
                      onTap: () async {
                        final amount = await openDialog();
                        if (amount == null || amount.isEmpty) return;
                        setState(() {
                          this.amount += int.tryParse(amount) ?? 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Text(
                          'เติมเงิน',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [],
          )
        ],
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('กรุณาใส่จำนวนเงิน'),
          content: TextField(
            autofocus: true,
            // decoration: InputDecoration(
            //   hintText: Text('0 - 1000'),
            // ),
            controller: amountController,
            onSubmitted: (_) => submit(),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: submit,
              child: Text('ยืนยัน'),
            ),
          ],
        ),
      );

  Future submit() async {
    if (double.tryParse(amountController.text) != null &&
        (double.tryParse(amountController.text)! >= 1)) {
      await firestore
          .collection('Profile')
          .doc(auth.currentUser?.uid)
          .collection('transaction')
          .add({
        'totalAmount': totalAmount + int.tryParse(amountController.text)!,
        'amount': int.tryParse(amountController.text)!,
        'option': 'i',
        'timeStamp': DateTime.timestamp()
      });

      Navigator.of(context).pop(amountController.text);
      amountController.clear();
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'คำเตือน',
        text: 'กรุณาใส่จำนวนเงินให้ถูกต้อง',
      );
    }
  }
}
