import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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
  double amount = 300.00;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = '';
  Uint8List? _image;
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

  void saveData() async {
    try {
      String title = _txtControllerBody.text;

      if (amount > 50.00) {
        ServiceDeliver().saveDeliver(title: title, file: _image!, uid: uid);
        _txtControllerBody.clear();
        Navigator.pop(context);
        print(amount);
      } else {
        Fluttertoast.showToast(msg: "กรุณาเติมเงิน");
        print(amount);
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DelivererScreen(),
                  ));
            },
            icon: Icon(Icons.add),
          ),
        ],
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
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: themeBg),
              onPressed: () => {
                if (_formKey.currentState!.validate()) {saveData()}
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
}
