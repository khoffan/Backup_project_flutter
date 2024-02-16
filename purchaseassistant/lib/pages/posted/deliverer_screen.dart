import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchaseassistant/services/wallet_service.dart';
import 'package:purchaseassistant/utils/constants.dart';

import '../../services/delivers_services.dart';
import '../../services/pickerimg.dart';
import 'deliverer_history.dart';

class DelivererScreen extends StatefulWidget {
  const DelivererScreen({super.key});

  @override
  State<DelivererScreen> createState() => _DelivererScreenState();
}

class _DelivererScreenState extends State<DelivererScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  late StreamSubscription<double> subscription;
  double amount = 0.00;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = '';
  Uint8List? _image;
  double dischange = 0.00;
  bool isCheckedAday = false;
  bool isChecked3day = false;
  bool isChecked5day = false;
  bool isChecked7day = false;

  void selecImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    if (img == '') {
      print("no ok");
    }
    print("ok");
  }

  void saveData(String duration) async {
    try {
      String title = _txtControllerBody.text;

      if (amount > 50.00) {
        ServiceDeliver().saveDeliverPosts(
          title: title,
          file: _image!,
          uid: uid,
          duration: duration,
        );
        _txtControllerBody.clear();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "กรุณาเติมเงิน");
      }
      print('success');
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
              // Future.delayed(Duration(seconds: 1), () {
              //   alertNOtAmout(context);
              // });
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

  void exchangePost() async {
    try {
      print("dischange: $dischange");
      await ServiceWallet().setExchangeAmount(uid, dischange, amount);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid ?? '';
    getAmount(context, uid);
    print(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สร้างโพสต์รับหิ้ว',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: themeBg,
        leading: GestureDetector(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          _image != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black38,
                      ),
                      onPressed: () {
                        selecImage();
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(image: MemoryImage(_image!))))
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black38,
                      ),
                      onPressed: () {
                        selecImage();
                      },
                    ),
                  )),
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: _txtControllerBody,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                validator: (val) =>
                    val!.isEmpty ? 'กรุณาใส่ข้อความก่อนทำการอัปโหลด' : null,
                decoration: InputDecoration(
                  hintText: 'พิมพ์ข้อความรับหิ้วสินค้า',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.00),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _checkedBox(
                  title: '1 วัน',
                  ckecked: isCheckedAday,
                  onChange: (value) {
                    setState(() {
                      isCheckedAday = value!;
                      double buy = 10.00;
                      dischange = buy;
                    });
                  },
                ),
                _checkedBox(
                  title: '3 วัน',
                  ckecked: isChecked3day,
                  onChange: (value) {
                    setState(() {
                      isChecked3day = value!;
                      double buy = 15.00;
                      dischange = buy;
                    });
                  },
                ),
                _checkedBox(
                  title: '5 วัน',
                  ckecked: isChecked5day,
                  onChange: (value) {
                    setState(() {
                      isChecked5day = value!;
                      double buy = 20.00;
                      dischange = buy;
                    });
                  },
                ),
                _checkedBox(
                  title: '7 วัน',
                  ckecked: isChecked7day,
                  onChange: (value) {
                    setState(() {
                      isChecked7day = value!;
                      double buy = 25.00;
                      dischange = buy;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: themeBg),
              onPressed: () {
                String dayDuration = "";
                if (_formKey.currentState!.validate()) if (isCheckedAday)
                  dayDuration = "1วัน";
                if (isChecked3day) dayDuration = "3วัน";
                if (isChecked5day) dayDuration = "5วัน";
                if (isChecked7day) dayDuration = "7วัน";
                saveData(dayDuration);

                exchangePost();
              },
              child: Text(
                'อัปโหลด',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _checkedBox(
      {required String title,
      required bool ckecked,
      required ValueChanged<bool?> onChange}) {
    return Row(
      children: [
        Checkbox(value: ckecked, onChanged: onChange),
        Text(
          '$title',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }
}
