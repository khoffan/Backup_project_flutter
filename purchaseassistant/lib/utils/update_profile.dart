import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_services.dart';
import '../services/pickerimg.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({super.key, required this.data, required this.uid});

  String uid = "";
  Map<String, dynamic> data = {};

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

TextEditingController nameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController roomController = TextEditingController();
TextEditingController stdidController = TextEditingController();
TextEditingController dormController = TextEditingController();
TextEditingController genderController = TextEditingController();
TextEditingController phoneController = TextEditingController();

List<String> list = <String>['ชาย', 'หญิง'];

String dropdownValue = list.first; // Default value for dropdown

class _UpdateProfileState extends State<UpdateProfile> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();

  void valueItem(value) {
    setState(() {
      dropdownValue = value;
    });
  }

  String _image = "";
  bool imgState = false;
  String? newImage;
  void selectImage() async {
    final pickImag = ImagePicker();
    final pickImagURL = await pickImag.pickImage(source: ImageSource.gallery);
    if (pickImagURL != null) {
      final imageFile = File(pickImagURL.path);

      final imageURL =
          await AddProfile().uploadImagetoStorage('/profileImage', imageFile);

      newImage = imageURL;
    }
  }

  void updateProfile() async {
    String name = nameController.text;
    String room = roomController.text;
    String stdid = stdidController.text;
    String dorm = dormController.text;
    String phone = phoneController.text;
    String lname = lastnameController.text;

    if (name.isNotEmpty &&
        room.isNotEmpty &&
        stdid.isNotEmpty &&
        dorm.isNotEmpty &&
        lname.isNotEmpty &&
        room.isNotEmpty &&
        phone.isNotEmpty &&
        dropdownValue.isNotEmpty &&
        imgState == false) {
      await AddProfile().updateProfile(
        name: name,
        room: room,
        file: _image,
        stdid: stdid,
        dorm: dorm,
        gender: dropdownValue,
        phone: phone,
        lname: lname,
      );
    } else {
      await AddProfile().updateProfile(
        name: name,
        room: room,
        file: newImage!,
        stdid: stdid,
        dorm: dorm,
        gender: dropdownValue,
        phone: phone,
        lname: lname,
      );
    }
    nameController.clear();
    roomController.clear();
    stdidController.clear();
    dormController.clear();
    lastnameController.clear();
    phoneController.clear();

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.data["name"] ?? '';
    lastnameController.text = widget.data["lname"] ?? '';
    stdidController.text = widget.data["stdid"] ?? '';
    roomController.text = widget.data["room"] ?? '';
    dormController.text = widget.data["dorm"] ?? '';
    genderController.text = widget.data["gender"] ?? '';
    phoneController.text = widget.data["phone"] ?? '';
    dropdownValue = widget.data["gender"] ?? '';
    _image = widget.data['imageLink'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: firebase,
        builder: (context, snap) {
          if (snap.hasError) {
            return Scaffold(
              appBar: AppBar(title: Text("Error")),
              body: Center(child: Text("${snap.error}")),
            );
          }
          if (snap.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            _image != null && newImage == null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(_image),
                                  )
                                : CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(newImage!),
                                  ),
                            Positioned(
                              child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  size: 28,
                                ),
                              ),
                              bottom: -10,
                              left: 210,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "รหัสนักศึกษา", valueItem),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "ชื่อ", valueItem),
                                  _buildTextFieldOrder(
                                      context, "นามสกุล", valueItem),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "หอ", valueItem),
                                  _buildTextFieldOrder(
                                      context, "หมายเลขห้อง", valueItem),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildTextFieldOrder(
                                      context, "เพศ", valueItem),
                                  _buildTextFieldOrder(
                                      context, "โทรศัพท์", valueItem),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                updateProfile();
                              }
                            },
                            child: Text("Save profile"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

Widget _buildTextFieldOrder(
    context, String title, Function(String) valueItemCallback) {
  if (title == 'รหัสนักศึกษา') {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: stdidController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'ชื่อ') {
    return Container(
      width: 180,
      // width: MediaQuery.of(context).size.width / 2.2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: nameController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'นามสกุล') {
    return Container(
      width: 190,
      // width: MediaQuery.of(context).size.width / 2.1,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: lastnameController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }

  if (title == 'หอ') {
    return Container(
      width: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: dormController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'หมายเลขห้อง') {
    return Container(
      width: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: roomController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'เพศ') {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 60,
      child: DropdownButton<String>(
        value: dropdownValue,
        elevation: 10,
        isExpanded: true,
        onChanged: (String? value) {
          if (value != null) {
            valueItemCallback(value);
            print(
                list.indexOf(value).toString()); // You don't need to use ! here
          }
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              "  " + value,
              style: TextStyle(color: Colors.black54),
            ),
          );
        }).toList(),
      ),
    );
  }
  if (title == 'โทรศัพท์') {
    return Container(
      width: 190,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: title),
        controller: phoneController,
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "กรุณาใส่ข้อมูล";
          }
          return null;
        },
      ),
    );
  }
  return Container();
}
