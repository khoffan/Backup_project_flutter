import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchaseassistant/utils/constants.dart';

import '../../services/profile_services.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
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

class _EditProfileState extends State<EditProfile> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();

  void valueItem(value) {
    setState(() {
      dropdownValue = value;
    });
  }

  String? _image;
  void selectImage() async {
    final picker = ImagePicker();
    final pickImageURL = await picker.pickImage(source: ImageSource.gallery);
    if (pickImageURL != null) {
      final img = File(pickImageURL.path);

      final imgurl =
          await ProfileService().uploadImagetoStorage('/profileImage', img);
      setState(() {
        _image = imgurl;
      });
    }
  }

  void saveFile() async {
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
        dropdownValue.isNotEmpty) {
      await ProfileService().saveProfile(
        name: name,
        room: room,
        file: _image!,
        stdid: stdid,
        dorm: dorm,
        gender: dropdownValue,
        phone: phone,
        lname: lname,
      );
      nameController.clear();
      roomController.clear();
      stdidController.clear();
      dormController.clear();
      lastnameController.clear();
      phoneController.clear();
      Navigator.pop(context);
    }
    // print(room);
    // print(name);
    // print(lname);
    // print(dorm);
    // print(phone);
    // print(dropdownValue);
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
              appBar: AppBar(
                title: Text(
                  'สร้างโปรไฟล์',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                backgroundColor: themeBg,
                automaticallyImplyLeading: false,
              ),
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
                            _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(_image!),
                                  )
                                : const CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                        'https://i.pinimg.com/564x/37/c6/ee/37c6ee12369d470152c3cbe592477703.jpg'),
                                  ),
                            Positioned(
                              child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  size: 28,
                                ),
                              ),
                              bottom: -10,
                              left: 210,
                            )
                          ],
                        ),
                        const SizedBox(
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
                              const SizedBox(
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
                              const SizedBox(
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
                              const SizedBox(
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
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: themeBg, // Background color
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (_image != null) {
                                  saveFile();
                                } else {
                                  const Text("no data");
                                }
                              }
                            },
                            child: const Text(
                              "Save profile",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
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
