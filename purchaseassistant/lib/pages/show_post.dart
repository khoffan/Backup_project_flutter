import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchaseassistant/pages/chat_screen.dart';
import 'package:purchaseassistant/utils/chat_services.dart';

// import '../utils/add_comments.dart';
import '../utils/delivers_services.dart';
import 'comment_screen.dart';

class ShowPost extends StatefulWidget {
  ShowPost({super.key});

  String postId = "";
  @override
  State<ShowPost> createState() => _ShowPostState();
}

final _formKey = GlobalKey<FormState>();
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

TextEditingController _messageController = TextEditingController();

class _ShowPostState extends State<ShowPost> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? uid;
  String userId = '';

  // void saveComment(String docid) async {
  //   try {
  //     String comment = _commentController.text;

  //     await ServiceDeliver()
  //         .saveDeliverComment(uid: uid ?? '', title: comment, postId: docid);
  //     _commentController.clear();
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }
  void saveChat(String userid, String name) async {
    try {
      String message = _messageController.text;
      print(userid);
      await ChatServices().sendMessge(userId, message, name);
      _messageController.clear();
    } catch (e) {
      throw e.toString();
    }
  }

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

                      String docid = deliverUserDoc.id;
                      String userid = deliverDoc.id;
                      userId = userid;
                      String name = deliverUser['name'] ?? '';
                      String lname = deliverUser['lname'] ?? '';
                      String title = deliverUser['title'] ?? '';
                      String imageLink = deliverUser['imageurl'] ?? '';
                      // print("DocId: ${userid}");
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
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return _showDiaslogProfile(
                                                context, userid);
                                          },
                                        );
                                      },
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
                                  child: imageLink != ''
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
                                  onPressed: () {
                                    
                                      ShowCommentBottm(context, saveChat, name);
                                  },
                                  child: Text('chat'),
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

  Future ShowCommentBottm(context, Function saveChat, String name) {
    print("PostId: ${userId}");
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          body: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: ChatScreen(
                      reciveuid: userId,
                      name: name,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 50,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty && value == '') {
                              return "กรุณาใส่ข้อมูล";
                            }
                            return null;
                          },
                          controller: _messageController,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            saveChat(userId, name);
                          }
                        },
                        icon: Icon(
                          Icons.send_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Future ShowCommentBottm(
//     context, Function saveComment, String postId, String uid) {
//   print("PostId: ${postId}");
//   return showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return Scaffold(
//         body: Container(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Expanded(
//                   flex: 4,
//                   child: ChatScreen(
//                     postId: postId,
//                     name: uid, reciveuid: '',
//                   ),
//                 ),

//                 Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 10),
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value!.isEmpty && value == '') {
//                           return "กรุณาใส่ข้อมูล";
//                         }
//                         return null;
//                       },
//                       controller: _messageController,
//                     )),
//                 // SizedBox(
//                 //   height: 10,
//                 // ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       saveComment(postId);
//                     }
//                   },
//                   child: Text("comment"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> _showDiaslogProfile(
  BuildContext context,
  String uid,
) {
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: _firestore.collection('userProfile').doc(uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }
      if (!snapshot.hasData) {
        return Center(
          child: Text("No information"),
        );
      }
      final userData = snapshot.data?.data() ?? {};

      return _buildProfileDialog(context, userData);
    },
  );
}

Widget _buildProfileDialog(
    BuildContext context, Map<String, dynamic> userData) {
  if (userData != '') {
    String image = userData['imageLink'] ?? '';
    return AlertDialog(
      title: CircleAvatar(
        backgroundImage: NetworkImage(
          image,
          scale: 0.8,
        ),
        maxRadius: 40,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Name: ${userData['name'] ?? ''} ${userData['lname'] ?? ''}'),
            Text('Phone: ${userData['phone'] ?? ''}'),
            // Add more profile information here
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Exit'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  return Container();
}
