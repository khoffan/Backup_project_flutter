import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchaseassistant/services/comment_services.dart';
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

// TextEditingController _messageController = TextEditingController();
TextEditingController _commentController = TextEditingController();

class _ShowPostState extends State<ShowPost> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? uid;
  Set<String> likedUserIds = Set<String>();
  int likeCount = 0;
  bool isLiked = false;
  String _docid = '';
  String _userid = '';

  void saveComment(String docid, String comment, String uid) async {
    try {
      String comment = _commentController.text;

      await ServiceComment()
          .saveDeliverComment(uid: uid, title: comment, postId: docid);
      _commentController.clear();
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
                      String name = deliverUser['name'] ?? '';
                      String lname = deliverUser['lname'] ?? '';
                      String title = deliverUser['title'] ?? '';
                      String imageLink = deliverUser['imageurl'] ?? '';
                      // print("userId: ${userid}");
                      // print("DocId: ${docid}");
                      final Timestamp timestamp = Timestamp.now();
                      final datenow = timestamp.toDate();
                      final date = DateFormat('d-MMM-yyyy').format(datenow);
                      return Card(
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                                child: Row(
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
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20.0, right: 30),
                                          child: Text("${name} ${lname}"),
                                        ),
                                        Text(date),
                                      ],
                                    ),
                                    Icon(
                                      Icons.more_vert,
                                      size: 20,
                                    ),
                                  ],
                                ),
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
                                    onPressed: () {
                                      ShowCommentBottm(context, saveComment,
                                          docid, uid ?? '');
                                    },
                                    child: Text('comment'),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

Future ShowCommentBottm(
    context, Function saveComment, String postId, String uid) {
  print("PostId: ${postId}");
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Form(
          key: _formKey,
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
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Comment",
                        ),
                        controller: _commentController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณาใส่ข้อมูล";
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String comment = _commentController.text;
                          saveComment(postId, comment, uid);
                          _commentController.clear();
                        }
                      },
                      icon: Icon(Icons.send_outlined),
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

// Future ShowCommentBottm(context, Function saveChat, String name) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Scaffold(
//           body: Container(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Expanded(
//                     flex: 4,
//                     child: ChatScreen(
//                       reciveuid: _userid,
//                       name: name,
//                       docid: _docid,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width - 50,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 10),
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty && value == '') {
//                               return "กรุณาใส่ข้อมูล";
//                             }
//                             return null;
//                           },
//                           controller: _messageController,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             saveChat(_userid, _docid);
//                           }
//                         },
//                         icon: Icon(
//                           Icons.send_outlined,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

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
