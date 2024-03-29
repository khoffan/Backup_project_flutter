import 'dart:async';
import 'dart:io';
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

  double dischange = 0.00;
  bool isCheckedAday = false;
  bool isChecked3day = false;
  bool isChecked5day = false;
  bool isChecked7day = false;

  String? _image;
  void selectImage() async {
    final picker = ImagePicker();
    final pickImageURL = await picker.pickImage(source: ImageSource.gallery);
    if (pickImageURL != null) {
      final img = File(pickImageURL.path);

      final imgurl =
          await ServiceDeliver().uploadImagetoStorage('deliverImage', img);
      setState(() {
        _image = imgurl;
      });
    }
  }

  void saveData(String duration) async {
    try {
      String title = _txtControllerBody.text;

      if (title.isEmpty) {
        Fluttertoast.showToast(msg: "กรุณากรอกข้อมูลให้ครบถ้วน");
        return;
      }

      if (duration.isEmpty) {
        Fluttertoast.showToast(msg: "กรุณาเลือกวันเวลาที่ต้องการ");
        return;
      }

      if (_image == null) {
        Fluttertoast.showToast(msg: "กรุณาเลือกรูปภาพสินค้า");
        return;
      }
      if (duration.isNotEmpty && _image != null) {
        ServiceDeliver().saveDeliverPosts(
          title: title,
          imageurl: _image!,
          uid: uid,
          duration: duration,
        );
        _txtControllerBody.clear();
        Navigator.pop(context);
      }

      print('success');
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid ?? '';
    // getAmount(context, uid);
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_image!),
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(
                    child: Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.black38,
                        ),
                        onPressed: () {
                          selectImage();
                        },
                      ),
                    ),
                  ),
                ),
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

                // exchangePost();
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
