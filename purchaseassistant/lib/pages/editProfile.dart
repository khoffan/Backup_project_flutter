import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/add_profile.dart';
import '../utils/pickerimg.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

TextEditingController nameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController rommController = TextEditingController();
TextEditingController stdidController = TextEditingController();
TextEditingController dormController = TextEditingController();
TextEditingController genderController = TextEditingController();
TextEditingController phoneController = TextEditingController();

List<String> list = <String>['ชาย', 'หญิง'];

String dropdowmValue = list.first; // Default value for dropdown

class _EditProfileState extends State<EditProfile> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();

  void valueItem(value) {
    setState(() {
      dropdowmValue = value;
    });
  }

  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveFile() async {
    String name = nameController.text;
    String room = rommController.text;
    String stdid = stdidController.text;
    String dorm = dormController.text;
    String gender = genderController.text;
    String phone = phoneController.text;
    String lname = lastnameController.text;

    await AddProfile().saveProfile(
      name: name,
      room: room,
      file: _image!,
      stdid: stdid,
      dorm: dorm,
      gender: gender,
      phone: phone,
      lname: lname,
    );
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
          } else if (snap.connectionState == ConnectionState.done) {
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
                            _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: MemoryImage(_image!),
                                  )
                                : CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                        'https://www.google.com/imgres?imgurl=https%3A%2F%2Fw7.pngwing.com%2Fpngs%2F205%2F731%2Fpng-transparent-default-avatar-thumbnail.png&tbnid=vj1POnmqwlZL-M&vet=12ahUKEwiv1vzRpZqAAxX-0qACHdgLBcgQMygCegUIARDlAQ..i&imgrefurl=https%3A%2F%2Fwww.pngwing.com%2Fen%2Fsearch%3Fq%3Ddefault&docid=J354HYBi_egj6M&w=360&h=360&q=default%20avatar%20in%20png&hl=en&ved=2ahUKEwiv1vzRpZqAAxX-0qACHdgLBcgQMygCegUIARDlAQ'),
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
                          child: Column(children: [
                            _buildTextFeildOrder(
                                context, "รหัสนักศึกษา", valueItem),
                            _buildTextFeildOrder(context, "ชื่อ", valueItem),
                            _buildTextFeildOrder(context, "นามสกุล", valueItem),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTextFeildOrder(
                                    context, "หอพัก", valueItem),
                                _buildTextFeildOrder(
                                    context, "ห้อง", valueItem),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTextFeildOrder(context, "เพศ", valueItem),
                                _buildTextFeildOrder(
                                    context, "โทรศัพท์", valueItem),
                              ],
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                saveFile();
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
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildTextFeildOrder(
    context, String title, Function(String) valueItemCallback) {
  if (title == 'รหัสนักศึกษา') {
    return Container(
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
            return "Please add a stdid";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'ชื่อ') {
    return Container(
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
            return "Please add a stdid";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'นามสกุล') {
    return Container(
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
            return "Please add a stdid";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'ห้อง') {
    return Container(
      width: 140,
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
            return "Please add a stdid";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'หอพัก') {
    return Container(
      width: 140,
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
            return "Please add a stdid";
          }
          return null;
        },
      ),
    );
  }
  if (title == 'เพศ') {
    return Container(
      width: 140,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
        value: dropdowmValue,
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
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  if (title == 'โทรศัพท์') {
    return Container(
      width: 140,
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
            return "Please add a stdid";
          }
          return null;
        },
      ),
    );
  }
  return Container();
}
