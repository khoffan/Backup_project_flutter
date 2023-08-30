import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowPost extends StatefulWidget {
  const ShowPost({super.key});

  @override
  State<ShowPost> createState() => _ShowPostState();
}

class _ShowPostState extends State<ShowPost> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('deliverPost').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final deliverDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: deliverDocs.length,
          itemBuilder: (context, index) {
            final deliverDoc = deliverDocs[index];
            final deliverUserCollection =
                deliverDoc.reference.collection('deliverContent');
            return StreamBuilder(
              stream: deliverUserCollection.snapshots(),
              builder: (context, deliverSnapshot) {
                if (deliverSnapshot.hasError) {
                  return Center(
                    child: Text(deliverSnapshot.error.toString()),
                  );
                }
                if (deliverSnapshot.connectionState ==
                    ConnectionState.waiting) {
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

                      String name = deliverUser['name'] ?? '';
                      String lname = deliverUser['lname'] ?? '';
                      String title = deliverUser['title'] ?? '';
                      String imageLink = deliverUser['imageurl'] ?? '';
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  onPressed: () {},
                                  child: Text('comment'),
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
    );
  }
}
