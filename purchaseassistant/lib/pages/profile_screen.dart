// import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:purchaseassistant/models/login.dart';
// import 'package:purchaseassistant/pages/home_screen.dart';

import '../utils/pickerimg.dart';
import 'editProfile.dart';
import 'login_screen.dart';

class ProfileScreenApp extends StatefulWidget {
  const ProfileScreenApp({super.key});

  @override
  State<ProfileScreenApp> createState() => _ProfileScreenAppState();
}

class _ProfileScreenAppState extends State<ProfileScreenApp> {
  final Future<FirebaseApp> _firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickerImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 74, 183, 0),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://www.google.com/imgres?imgurl=https%3A%2F%2Fw7.pngwing.com%2Fpngs%2F205%2F731%2Fpng-transparent-default-avatar-thumbnail.png&tbnid=vj1POnmqwlZL-M&vet=12ahUKEwiv1vzRpZqAAxX-0qACHdgLBcgQMygCegUIARDlAQ..i&imgrefurl=https%3A%2F%2Fwww.pngwing.com%2Fen%2Fsearch%3Fq%3Ddefault&docid=J354HYBi_egj6M&w=360&h=360&q=default%20avatar%20in%20png&hl=en&ved=2ahUKEwiv1vzRpZqAAxX-0qACHdgLBcgQMygCegUIARDlAQ'),
                        ),
                  Positioned(
                    child: IconButton(
                      onPressed: () {
                        // selectImage();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 28,
                      ),
                    ),
                    bottom: -10,
                    left: 80,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Center(
              //   child: SizedBox(
              //     width: 200,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.of(context).push(
              //           MaterialPageRoute(builder: (context) => EditProfile()),
              //         );
              //       },
              //       child: Text("Edit profile"),
              //     ),
              //   ),
              // ),
              Center(
                child: Column(children: [
                  Text(
                    "ข้อมูลผู้ใช้",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Text(auth.currentUser.email!),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
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
                              return const LoginScreen();
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
