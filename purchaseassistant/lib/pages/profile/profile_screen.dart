import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/utils/constants.dart';
import '../../routes/routes.dart';
import '../../utils/update_profile.dart';
import '../auth/login_screen.dart';
import 'add_profile.dart';

class ProfileScreenApp extends StatefulWidget {
  const ProfileScreenApp({super.key, required this.myNavigate});

  final Function myNavigate;

  @override
  State<ProfileScreenApp> createState() => _ProfileScreenAppState();
}

class _ProfileScreenAppState extends State<ProfileScreenApp> {
  final Future<FirebaseApp> _firebase = Firebase.initializeApp();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  CollectionReference amount =
      FirebaseFirestore.instance.collection('transaction');

  String name = "";
  String lname = "";
  String phone = "";
  String stdid = "";
  String gender = "";
  String room = "";
  String dorm = "";
  String image = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('userProfile')
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic> data = {};
          if (snapshot.hasData && snapshot.data!.exists) {
            final snapData = snapshot.data!.data() as Map<String, dynamic>;
            if (data != '') {
              data = snapData;
              name = data["name"] ?? '';
              lname = data["lname"] ?? '';
              stdid = data["stdid"] ?? '';
              room = data["room"] ?? '';
              dorm = data["dorm"] ?? '';
              gender = data["gender"] ?? '';
              phone = data["phone"] ?? '';
              image = data["imageLink"] ?? '';

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: themeBg,
                  leading: IconButton(
                      onPressed: () {
                        widget.myNavigate();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
                  actions: [
                    IconButton(
                      onPressed: () {
                        showMediaBottom(context);
                      },
                      icon: const Icon(
                        Icons.dehaze,
                        color: Colors.black,
                      ),
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
                                  if (data == '') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(),
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProfile(
                                          uid: auth.currentUser!.uid,
                                          data: data,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
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
                      const Center(
                        child: Text(
                          "ข้อมูลโปรไฟล์",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                          child: Container(
                        padding: const EdgeInsets.only(left: 40, top: 30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "ชื่อ :  ${name}  ${lname}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "รหัสนักศึกษา :  ${stdid}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "ที่อยู่ :  หอพักอาคาร ${dorm}  ห้อง ${room}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "เพศ :  ${gender}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "เบอร์โทรศัพท์ :  ${phone}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                StreamBuilder(
                                  stream: amount
                                      .doc(auth.currentUser?.uid)
                                      .collection('details')
                                      .snapshots(),
                                  // initialData: initialData,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return Row(
                                      children: [
                                        OutlinedButton(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.wallet,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                '  ยอดเงินคงเหลือ 0.00 บาท',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              Icon(
                                                Icons.arrow_right_outlined,
                                                color: Colors.black,
                                              )
                                            ],
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, AppRoute.wallet);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                // OutlinedButton(
                                //   child: Row(
                                //     children: [
                                //       Icon(
                                //         Icons.wallet,
                                //         color: Colors.black,
                                //       ),
                                //       Text(
                                //         '  ยอดเงินคงเหลือ ${_firestore.collection('transaction').doc(auth.currentUser?.uid).collection('details').snapshots().} บาท',
                                //         style: TextStyle(
                                //             color: Colors.black, fontSize: 16),
                                //       ),
                                //       Icon(
                                //         Icons.arrow_right_outlined,
                                //         color: Colors.black,
                                //       )
                                //     ],
                                //   ),
                                //   onPressed: () {
                                //     Navigator.pushNamed(
                                //         context, AppRoute.wallet);
                                //   },
                                // ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const EditProfile();
            }
          } else {
            return const EditProfile();
          }
        });
  }

  Future showMediaBottom(context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }));
                        });

                        // Add Logout here
                      },
                      child: const Text("Sign Out"),
                    ),
                  ),
                ),
              ],
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.key)),
            TextButton(
              onPressed: () {},
              child: Text(
                title,
                style: const TextStyle(
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.person_2)),
            TextButton(
              onPressed: () {},
              child: Text(title,
                  style: const TextStyle(
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
                icon: const Icon(
                  Icons.person,
                  color: Colors.red,
                )),
            TextButton(
              onPressed: () {},
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.red),
              ),
            )
          ]),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {},
        child: const SizedBox(),
      );
    }
  }
}
