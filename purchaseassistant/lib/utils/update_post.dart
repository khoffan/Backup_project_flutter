import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchaseassistant/services/delivers_services.dart';

import '../services/pickerimg.dart';

class UpdatePosted extends StatefulWidget {
  UpdatePosted(
      {super.key,
      required this.postedDocid,
      required this.postedUserid,
      required this.title,
      required this.imageLink});

  String postedDocid = "";
  String postedUserid = "";
  String title = "";
  String imageLink = "";

  @override
  State<UpdatePosted> createState() => _UpdatePostedState();
}

class _UpdatePostedState extends State<UpdatePosted> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _txtControllerBody = TextEditingController();
  String _image = "";
  Uint8List? _newImage;

  void selecImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      _newImage = img;
    });
    if (img == '') {
      print("no ok");
    }
    print("ok");
  }

  void updateData() async {
    try {
      String title = _txtControllerBody.text;
      String uid = widget.postedUserid;
      String Docid = widget.postedDocid;
      await ServiceDeliver()
          .updateDeliver(uid: uid, Docid: Docid, title: title, file: _newImage ?? Uint8List(0));
      print("update success");
      Navigator.pop(context);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _txtControllerBody.text = widget.title;
    _image = widget.imageLink;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliverer'),
      ),
      body: ListView(
        children: [
          _image != null && _newImage == null
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
                    image: DecorationImage(
                      image: NetworkImage(_image),
                    ),
                  ),
                )
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
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_newImage!),
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
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue),
              onPressed: () => {
                if (_formKey.currentState!.validate()) {updateData()}
              },
              child: Text('อัปโหลด'),
            ),
          )
        ],
      ),
    );
  }
}

