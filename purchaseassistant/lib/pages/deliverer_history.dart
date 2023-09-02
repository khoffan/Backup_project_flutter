import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/utils/delivers_services.dart';
import 'package:intl/intl.dart';

import 'deliverer_screen.dart';

class DeliverHistory extends StatefulWidget {
  const DeliverHistory({super.key});

  @override
  State<DeliverHistory> createState() => _DeliverHistoryState();
}

class _DeliverHistoryState extends State<DeliverHistory> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";

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
        title: Text("History Posted"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () {
                Navigator.pop(context);
                ServiceDeliver().updateStatus(false, uid);
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
                  builder: (_) => DelivererScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
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

          final fillterDeliver = deliverDocs.where((deliverDoc) => deliverDoc.id == spacificuser).toList();
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
                                children: [
                                  Expanded(
                                    child: imageLink != null
                                        ? Image(
                                            image: NetworkImage(
                                              imageLink,
                                            ),
                                            width: 40.0,
                                          )
                                        : Image(
                                            image: NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                            ),
                                            width: 40.0,
                                          ),
                                  ),
                                ],
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: (){},
                                    child: Text('edit'),
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
    );
  }
}
