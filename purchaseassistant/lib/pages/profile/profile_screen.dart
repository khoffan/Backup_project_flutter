import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/services/auth_service.dart';
import 'package:purchaseassistant/utils/constants.dart';
import '../../routes/routes.dart';
import '../../services/delivers_services.dart';
import '../../services/user_provider.dart';
import '../../utils/update_profile.dart';
import '../auth/login_screen.dart';
import 'add_profile.dart';
import 'package:quickalert/quickalert.dart';

class ProfileScreenApp extends StatefulWidget {
  const ProfileScreenApp({super.key, required this.myNavigate});

  final Function myNavigate;

  @override
  State<ProfileScreenApp> createState() => _ProfileScreenAppState();
}

class _ProfileScreenAppState extends State<ProfileScreenApp> {
  // final Future<FirebaseApp> _firebase = Firebase.initializeApp();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = "";
  String name = "";
  String lname = "";
  String phone = "";
  String stdid = "";
  String gender = "";
  String room = "";
  String dorm = "";
  String image = "";
  bool? sts;
  String checkuid() {
    if (uid == "") {
      return uid;
    } else {
      return uid;
    }
  }

  void signoutsubmit() async {
    await AuthServices().Signoutuser(context);
    await UserLogin.setLogin(false);
    sts = await UserLogin.getLogin();
    if (uid != "") {
      await ServiceDeliver().updateUser(uid, sts);
    }
    print(sts);
  }

  void initState() {
    super.initState();
    uid = auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('Profile').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  await AuthServices().Signoutuser(context);
                  await UserLogin.setLogin(false);
                  // Add Logout here
                },
                child: const Text("Sign Out"),
              ),
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
            if (data != null) {
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
                  title: const Text(
                    "โปรไฟล์และการตั้งค่า",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(color: Colors.black),
                  leading: IconButton(
                      onPressed: () {
                        if (widget.myNavigate() != null) {
                          widget.myNavigate();
                        }
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
                        color: themeBg.withRed(200),
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
                            StreamBuilder(
                              stream: _firestore
                                  .collection('Profile')
                                  .doc(uid)
                                  .collection("transaction")
                                  .orderBy("totalAmount", descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text("${snapshot.error}"),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.docs.isNotEmpty) {
                                  QueryDocumentSnapshot doc =
                                      snapshot.data!.docs.first;
                                  Map<String, dynamic> data =
                                      doc.data() as Map<String, dynamic>;
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
                                              '  ยอดเงินคงเหลือ ${data["totalAmount"]} บาท',
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
                                      const SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  );
                                } else {
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
                                      const SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  );
                                }
                              },
                            )
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
              if (uid == "") {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        signoutsubmit();
                      },
                      child: const Text("Sign Out"),
                    ),
                  ),
                );
              } else {
                return EditProfile();
              }
            }
          } else {
            if (uid == "") {
              return Container(
                margin: const EdgeInsets.all(10),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      signoutsubmit();
                    },
                    child: const Text("Sign Out"),
                  ),
                ),
              );
            } else {
              return EditProfile();
            }
          }
        });
  }

  Future showMediaBottom(context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildContentMedia(context, "ลบบัญชี"),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        signoutsubmit();
                      },
                      child: const Text(
                        "ออกจากระบบ",
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
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
    // if (title == "change password") {
    //   return GestureDetector(
    //     onTap: () {},
    //     child: Padding(
    //       padding: const EdgeInsets.only(top: 10),
    //       child: Row(children: [
    //         IconButton(onPressed: () {}, icon: const Icon(Icons.key)),
    //         TextButton(
    //           onPressed: () {},
    //           child: Text(
    //             title,
    //             style: const TextStyle(
    //                 fontSize: 15, color: Color.fromARGB(255, 56, 56, 56)),
    //           ),
    //         ),
    //       ]),
    //     ),
    //   );
    // } else if (title == "About me") {
    //   return GestureDetector(
    //     onTap: () {},
    //     child: Padding(
    //       padding: const EdgeInsets.only(top: 10),
    //       child: Row(children: [
    //         IconButton(onPressed: () {}, icon: const Icon(Icons.person_2)),
    //         TextButton(
    //           onPressed: () {},
    //           child: Text(title,
    //               style: const TextStyle(
    //                   fontSize: 15, color: Color.fromARGB(255, 56, 56, 56))),
    //         ),
    //       ]),
    //     ),
    //   );
    // } else
    if (title == "ลบบัญชี") {
      return GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            IconButton(
                onPressed: () async {
                  await AuthServices().delateUser(auth.currentUser!.uid);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.red,
                )),
            TextButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: 'ต้องการลบบัญชีนี้หรือไม่?',
                  text: 'เมื่อลบบัญชีแล้วไม่สามารถกู้คืนได้',
                  headerBackgroundColor: Colors.red,
                  confirmBtnText: 'ยืนยัน',
                  cancelBtnText: 'ยกเลิก',
                  confirmBtnColor: Colors.red,
                  onConfirmBtnTap: () async => {
                    await deleteUser(),
                    await signOut(),
                    Navigator.pushReplacementNamed(context, AppRoute.login),
                  },
                );
              },
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

  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.delete();
      debugPrint('User account deleted.');
    } catch (e) {
      debugPrint('Failed to delete user account: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    debugPrint('User signed out.');
  }
}
