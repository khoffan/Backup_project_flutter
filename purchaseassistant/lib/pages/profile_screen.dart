// import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:purchaseassistant/models/login.dart';
// import 'package:purchaseassistant/pages/home_screen.dart';

import '../utils/pickerimg.dart';
import '../utils/update_profile.dart';
import 'editProfile.dart';
import 'login_screen.dart';

class ProfileScreenApp extends StatefulWidget {
  const ProfileScreenApp({super.key});

  @override
  State<ProfileScreenApp> createState() => _ProfileScreenAppState();
}

class _ProfileScreenAppState extends State<ProfileScreenApp> {
  final Future<FirebaseApp> _firebase = Firebase.initializeApp();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String name = "";
  String lname = "";
  String phone = "";
  String stdid = "";
  String gender = "";
  String room = "";
  String dorm = "";
  String image = "";

  // Uint8List? _image;
  // void selectImage() async {
  //   Uint8List img = await pickerImage(ImageSource.gallery);
  //   setState(() {
  //     _image = img;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('userProfile')
            .doc(auth.currentUser?.uid ?? '')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!.data();
            name = data?["name"] ?? '';
            lname = data?["lname"] ?? '';
            stdid = data?["stdid"] ?? '';
            room = data?["room"] ?? '';
            dorm = data?["dorm"] ?? '';
            gender = data?["gender"] ?? '';
            phone = data?["phone"] ?? '';
            image = data?["imageLink"] ?? '';

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 242, 195, 245),
                actions: [
                  IconButton(
                    onPressed: () {
                      showMediabottom(context);
                    },
                    icon: Icon(Icons.dehaze),
                  )
                ],
              ),
              body: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.amber.withOpacity(0.1),
                      padding: const EdgeInsets.only(top: 40, bottom: 40),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      width: double.infinity,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          image != ''
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(image),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://www.google.com/imgres?imgurl=https%3A%2F%2Fw7.pngwing.com%2Fpngs%2F205%2F731%2Fpng-transparent-default-avatar-thumbnail.png&tbnid=vj1POnmqwlZL-M&vet=12ahUKEwiv1vzRpZqAAxX-0qACHdgLBcgQMygCegUIARDlAQ..i&imgrefurl=https%3A%2F%2Fwww.pngwing.com%2Fen%2Fsearch%3Fq%3Ddefault&docid=J354HYBi_egj6M&w=360&h=360&q=default%20avatar%20in%20png&hl=en&ved=2ahUKEwiv1vzRpZqAAxX-0qACHdgLBcgQMygCegUIARDlAQ'),
                                ),
                          Positioned(
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 28,
                                color: Colors.blue,
                              ),
                            ),
                            bottom: -10,
                            left: 230,
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        "ข้อมูลโปรไฟล์",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                        child: Container(
                      padding: EdgeInsets.only(left: 40, top: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "ชื่อ :  ${name}  ${lname}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "รหัสนักศึกษา :  ${stdid}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "ที่อยู่ :  หอพักอาคาร ${dorm}  ห้อง ${room}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "เพศ :  ${gender}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "เบอร์โทรศัพท์ :  ${phone}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateProfile(data: data!, uid: auth.currentUser?.uid ?? '',)));
                      },
                      child: Text("update profile"),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }

  Future showMediabottom(context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildContentMedia(context, "change password"),
                  buildContentMedia(context, "About me"),
                  buildContentMedia(context, "Delete Account"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          auth.signOut().then((value) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //         builder: (context) => const LoginScreen()),
                            //     (route) => false);
                          });
                          // Add authen logout hare
                        },
                        child: Text("Sign Out"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  GestureDetector buildContentMedia(context, String title) {
    if (title == "change password") {
      return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.key)),
            TextButton(
              onPressed: () {},
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 15, color: Color.fromARGB(255, 56, 56, 56)),
              ),
            ),
          ]),
        ),
      );
    } else if (title == "About me") {
      return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.person_2)),
            TextButton(
              onPressed: () {},
              child: Text(title,
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 56, 56, 56))),
            ),
          ]),
        ),
      );
    } else if (title == "Delete Account") {
      return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person,
                  color: Colors.red,
                )),
            TextButton(
              onPressed: () {},
              child: Text(
                title,
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )
          ]),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {},
        child: SizedBox(),
      );
    }
  }
}
