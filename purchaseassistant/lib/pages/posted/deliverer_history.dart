import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchaseassistant/Provider/deliverDataProvider.dart';
import 'package:purchaseassistant/models/matchmodel.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';
import 'package:purchaseassistant/pages/posted/comment_screen.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import 'package:intl/intl.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/services/profile_services.dart';
import 'package:purchaseassistant/utils/constants.dart';
import 'package:purchaseassistant/utils/formatDate.dart';

import '../../models/stremCheckingData.dart';
import '../../utils/update_post.dart';
import '../customer_loading.dart';
import '../profile/profile_screen.dart';
import 'deliverer_screen.dart';

class DeliverHistory extends StatefulWidget {
  DeliverHistory({super.key, this.riderLocate});

  String? riderLocate;

  @override
  State<DeliverHistory> createState() => _DeliverHistoryState();
}

class _DeliverHistoryState extends State<DeliverHistory> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  String riderLocate = "";
  DeliveryData deliData = DeliveryData();
  void removePosted(String uid, String docid) async {
    try {
      await ServiceDeliver().removeDeliverer(uid: uid, docid: docid).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ลบ Posted สำเร็จแล้ว',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่สามารถลบ Posted ได้',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            backgroundColor: Colors.red,
          ),
        );
      });
    } catch (e) {
      throw e.toString();
    }
  }

  void showMediaCustoerSide(BuildContext context, FirebaseFirestore store) {
    final StremChecingData customerStream =
        showCustomerStream(context, store, riderLocate);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: customerStream.hasdata != false
                    ? customerStream.widget
                    : Center(
                        child: Text("nodata"),
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  void riderConfirme(String uid, String docId, String cusname) async {
    Timestamp datetime = Timestamp.now();
    String datenow = FormatDate.date(datetime);
    if (uid != "") {
      DocumentSnapshot snapshot =
          await _firestore.collection("Profile").doc(uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        String name = data["name"];
        if (name != "") {
          Map<String, dynamic> userdata = {
            "id": uid,
            "name": name,
            "date": datenow,
          };

          await APIMatiching().updateDataRiderConfrime(userdata, docId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        reciveuid: docId,
                        name: cusname,
                      )));
        }
      }
    }
  }

  void navigetPOP() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    riderLocate = widget.riderLocate ?? "";
    print("riderlocate = ${riderLocate}");
  }

  @override
  Widget build(BuildContext context) {
    // final data = Provider.of<DeliveryDataProvider>(context);
    final spacificuser = uid;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "ประวัติการโพสต์",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          backgroundColor: themeBg,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // ServiceDeliver().updateStatus(false, uid);
                  ProfileService().updateRole(uid, "customer");
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    maximumSize: Size(100, 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none, // <-- Radius
                    ),
                    minimumSize: Size(30, 2),
                    backgroundColor: Colors.white38),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DelivererScreen(),
                    ),
                  );
                },
                child: Text(
                  "เพิ่มโพสต์",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreenApp(myNavigate: navigetPOP),
                  ),
                );
              },
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
            ),
          ]),
      body: StreamBuilder(
        stream: ServiceDeliver().streamPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          final deliverDocs = snapshot.data!.docs;

          final fillterDeliver = deliverDocs
              .where((deliverDoc) => deliverDoc.id == spacificuser)
              .toList();
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: fillterDeliver.length,
              itemBuilder: (context, index) {
                final deliverDoc = fillterDeliver[index];
                String refDocid = deliverDoc.id;
                final deliverUserDocs =
                    deliverDoc.reference.collection('Contents');
                return StreamBuilder(
                  stream: _firestore
                      .collection("Profile")
                      .doc(refDocid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("No data"),
                      );
                    }
                    Map<String, dynamic> profileData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    String imageProfile = profileData["imageLink"];
                    return StreamBuilder(
                      stream: deliverUserDocs.snapshots(),
                      builder: (context, deliverSnapshot) {
                        if (deliverSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${deliverSnapshot.error}'),
                          );
                        }
                        if (!deliverSnapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final deliveruserDocs = deliverSnapshot.data!.docs;

                        if (deliverSnapshot.hasData) {
                          return Column(
                            // Use a Column instead of nested ListView.builder
                            children: deliveruserDocs.map((deliverUserDoc) {
                              final deliverUser =
                                  deliverUserDoc.data() as Map<String, dynamic>;

                              String docid = deliverUserDoc.id;
                              String userId = deliverDoc.id;

                              String name = deliverUser['name'] ?? '';

                              String title = deliverUser['title'] ?? '';
                              String imageLink = deliverUser['imageurl'] ?? '';
                              // print("DocId: ${docid}");
                              Timestamp timestamp = deliverUser["date"];
                              String date = FormatDate.getdaytime(timestamp);
                              return Card(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            imageProfile != ""
                                                ? Container(
                                                    child: Image(
                                                      image: NetworkImage(
                                                        imageProfile,
                                                      ),
                                                      width: 30.0,
                                                    ),
                                                  )
                                                : Container(
                                                    child: Image(
                                                      image: NetworkImage(
                                                        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                                      ),
                                                      width: 40.0,
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              child: Text("${name}"),
                                            ),
                                          ],
                                        ),
                                        Text(date),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.more_vert,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("${title}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: imageLink != ''
                                              ? Image(
                                                  image: NetworkImage(
                                                    imageLink,
                                                  ),
                                                )
                                              : Image(
                                                  image: NetworkImage(
                                                    "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                                  ),
                                                  width: 40,
                                                ),
                                        ),
                                      ],
                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            ShowCommentBottm(
                                                context, docid, uid);
                                          },
                                          child: Text('รายการความคิดเห็น'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => UpdatePosted(
                                                      imageLink: imageLink,
                                                      postedDocid: docid,
                                                      postedUserid: userId,
                                                      title: title),
                                                ));
                                          },
                                          child: Text('แก้ไข'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            removePosted(userId, docid);
                                          },
                                          child: Text(
                                            'ลบ',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return Container();
                      },
                    );
                  },
                );
              },
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ไม่มีรายการที่ได้โพสต์ไว้",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "สามารถกดเพิ่มโพสต์ที่ปุ่มเพิ่มโพสต์ได้",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showMediaCustoerSide(context, FirebaseFirestore.instance);
        },
        child: Text(
          "จับคู่",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future ShowCommentBottm(context, String postId, String uid) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Form(
            child: Scaffold(
              appBar: AppBar(
                leading: null,
                backgroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: CommentScreen(
                      postId: postId,
                      uid: uid,
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

  Widget buildContent(Map<String, dynamic> customerdata, String docid) {
    String name = customerdata['cusname'];
    bool statusCus = customerdata["cus_status"];

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: themeBg,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Name: ${name}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("${customerdata['location']}")
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (statusCus == true) {
                                riderConfirme(uid, docid, name);
                              }
                            },
                            child: Text("ตอบรับ"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white)),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  StremChecingData showCustomerStream(
      BuildContext context, FirebaseFirestore firestore, String locaterider) {
    bool hasData = true;
    if (locaterider != "รับทุกงาน") {
      return StremChecingData(
        widget: StreamBuilder(
          stream: firestore
              .collection("Matchings")
              .where("location", isEqualTo: locaterider)
              .where("cusIsonline", isEqualTo: "online")
              .where("cus_status", isEqualTo: true)
              .where("status", isEqualTo: "InActive")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            if (!snapshot.hasData) {
              hasData = false;
              return Center(
                child: Text("No data in collection"),
              );
            }
            final customerDocs = snapshot.data!.docs;
            if (snapshot.hasData && customerDocs.isNotEmpty) {
              return ListView(
                  children: customerDocs.map((customerDoc) {
                final customerdata = customerDoc.data() as Map<String, dynamic>;
                return buildContent(customerdata, customerDoc.id);
              }).toList());
            } else {
              return Center(
                child: Text(
                  !hasData ? "ไม่มีรายการของลูกค้า" : "ไม่มีรายการของลูกค้า",
                  style: TextStyle(fontSize: 25),
                ),
              );
            }
          },
        ),
        hasdata: hasData,
      );
    }
    return StremChecingData(
      widget: StreamBuilder(
        stream: firestore
            .collection("Matchings")
            .where("cusIsonline", isEqualTo: "online")
            .where("cus_status", isEqualTo: true)
            .where("status", isEqualTo: "InActive")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (!snapshot.hasData) {
            hasData = false;
            return Center(
              child: Text("No data in collection"),
            );
          }
          final customerDocs = snapshot.data!.docs;

          if (snapshot.hasData && customerDocs.isNotEmpty) {
            return ListView(
                children: customerDocs.map((customerDoc) {
              final customerdata = customerDoc.data() as Map<String, dynamic>;
              return buildContent(customerdata, customerDoc.id);
            }).toList());
          } else {
            return Center(
              child: Text(
                !hasData ? "ไม่มีรายการของลูกค้า" : "ไม่มีรายการของลูกค้า",
                style: TextStyle(fontSize: 25),
              ),
            );
          }
        },
      ),
      hasdata: hasData,
    );
  }
}
