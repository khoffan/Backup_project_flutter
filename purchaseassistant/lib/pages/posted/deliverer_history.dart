import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchaseassistant/Provider/deliverDataProvider.dart';
import 'package:purchaseassistant/models/matchmodel.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import 'package:intl/intl.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/utils/constants.dart';

import '../../utils/update_post.dart';
import '../customer_loading.dart';
import '../profile/profile_screen.dart';
import 'deliverer_screen.dart';

class DeliverHistory extends StatefulWidget {
  DeliverHistory({super.key, this.cusid, this.riderid});

  final String? cusid;
  final String? riderid;

  @override
  State<DeliverHistory> createState() => _DeliverHistoryState();
}

class _DeliverHistoryState extends State<DeliverHistory> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  String cusid = "";
  String riderid = "";
  DeliveryData deliData = DeliveryData();
  void removePosted(String uid, String docid) async {
    try {
      await ServiceDeliver().removeDeliverer(uid: uid, docid: docid).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Content updated successfully')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error updating content')));
      });
    } catch (e) {
      throw e.toString();
    }
  }

  void navigetPOP() {
    Navigator.pop(context);
  }

  int findIndexData(List<Map<String, dynamic>> allData, String targetId) {
    for (int i = 0; i < allData.length; i++) {
      if (allData[i]["riderid"] == targetId) {
        return i;
      }
    }
    return -1;
  }

  bool? submituid1(BuildContext context, String riderid) {
    try {
      if (uid == riderid) {
        return true;
      }
      return false;
    } catch (e) {
      throw e.toString();
    }
  }

  void confrimeOrder(BuildContext context) async {
    try {} catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
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
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
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
            // Consumer(
            //   builder: (context, DeliveryDataProvider provider, _) {
            //     List<String> data = provider.getDeliveryData();
            //     if (data.isNotEmpty) {
            //       return IconButton(
            //         onPressed: () {
            //           print(data);
            //         },
            //         icon: Icon(
            //           Icons.notifications,
            //           color: Colors.black26,
            //         ),
            //       );
            //     }

            //     // Default case when deliveryData is null or cusid/riderid are empty
            //     return IconButton(
            //       onPressed: () {
            //         print("cusid and riderid not data");
            //       },
            //       icon: Icon(
            //         Icons.notifications,
            //         color: Colors.black26,
            //       ),
            //     );
            //   },
            // ),

            // IconButton(
            //   onPressed: () {
            //     // String cusid = data.getDeliveyDataCusid();
            //     // String riderid = data.getDeliveyDataRiderid();
            //     List<String> objdeli = deliData.getDeliveryId();
            //     if(objdeli.isNotEmpty){
            //       print(objdeli);
            //     }
            //     // print(cusid);
            //     // print(riderid);
            //   },
            //   icon: Icon(Icons.notifications),
            // ),
            IconButton(
              onPressed: () {
                confrimeOrder(context);
              },
              icon: Icon(Icons.notifications),
            ),
          ]),
      body: StreamBuilder(
        stream: _firestore.collection('deliverPost').snapshots(),
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
                final deliverUserDocs =
                    deliverDoc.reference.collection('deliverContent');
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
                          String lname = deliverUser['lname'] ?? '';
                          String title = deliverUser['title'] ?? '';
                          String imageLink = deliverUser['imageurl'] ?? '';
                          // print("DocId: ${docid}");
                          final Timestamp timestamp = Timestamp.now();
                          final datenow = timestamp.toDate();
                          final date = DateFormat('d-MMM-yyyy').format(datenow);
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
                                        Container(
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
                                          child: Text("${name} ${lname}"),
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
                                Row(
                                  children: [
                                    Text("${title}"),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                              width: 20,
                                            ),
                                    ),
                                  ],
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.end,
                                  children: [
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
                                      child: Text('Edit'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        removePosted(userId, docid);
                                      },
                                      child: Text('Remove'),
                                    ),
                                  ],
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
          } else {
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ไม่รายการที่ได้โพสไว้",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "สามารถกดเพิ่มโพศที่ปุ่มด้านซ้ายล่าง",
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DelivererScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
