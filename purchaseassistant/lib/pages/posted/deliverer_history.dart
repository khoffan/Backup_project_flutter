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
      if (allData[i]["cusid"] == targetId) {
        return i;
      }
    }
    return -1;
  }

  Future<bool?> submituid1(BuildContext context) async {
    try {
      List<Map<String, dynamic>> allData =
          await APIMatiching().getMatchingresult();
      for (Map<String, dynamic> data in allData) {
        int index = findIndexData(allData, uid);
        if (index != -1) {
          Map<String, dynamic> data = allData[index];
          if (uid == data["riderid"]) {
            return true;
          }
          return false;
        }
      }
      return null;
    } catch (e) {
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
            // Consumer<DeliveryDataProvider>(
            //   builder: (context, provider, chlid) {
            //     DeliveryData deliveryData = provider.getDeliveryData();
            //     String cusid = deliveryData.cusid.toString();
            //     String riderid = deliveryData.riderid.toString();
            //     return IconButton(
            //       onPressed: () {
            //         if (cusid.isNotEmpty && riderid.isNotEmpty) {
            //           print("cusid: ${cusid}, riderid: ${riderid} -> of 1");
            //         } else {
            //           print("data not found of submit 1");
            //         }
            //         // Additional logic if needed
            //         // For example, you can update the UI based on the data
            //       },
            //       icon: Icon(
            //         Icons.notifications,
            //         color: Colors.black26,
            //       ),
            //     );
            //   },
            // ),
            IconButton(
              onPressed: () {
                submituid1(context);
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
