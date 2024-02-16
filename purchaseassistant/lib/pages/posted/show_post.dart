import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/services/comment_services.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import 'package:purchaseassistant/services/profile_services.dart';
import '../../utils/formatDate.dart';
import 'comment_screen.dart';

class ShowPost extends StatefulWidget {
  ShowPost({super.key});

  // String postId = "";
  @override
  State<ShowPost> createState() => _ShowPostState();
}

final _formKey = GlobalKey<FormState>();
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

// TextEditingController _messageController = TextEditingController();
TextEditingController _commentController = TextEditingController();
String imageProfileLink = "";

class _ShowPostState extends State<ShowPost> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int likeCount = 0;
  bool isLiked = false;
  String uid = "";
  bool? showPost;

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

  void _showProfileDialog(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _showDiaslogProfile(context, uid);
      },
    );
  }

  void someFunction(String uid) async {
    String imageLink = await ProfileService().getImage(uid);
    // Now you can use imageLink as a regular String
    print(imageLink);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      showPost = true;
    });
    uid = _auth.currentUser?.uid ?? '';
    someFunction(uid);
    // isShowPost(isShowpost);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ServiceDeliver().streamPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        print("snapshot.data! :${snapshot.data!}");
        return fetchData(snapshot.data!);
      },
    );
  }

  Widget fetchData(QuerySnapshot? snapshot) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      return Container(
        child: Text("No data in collection"),
      );
    }

    bool isShowpost = false; // Initialize isShowpost

    // Create a list to store the widgets for each document
    List<Widget> widgets = [];

    // Use Future to fetch data outside FutureBuilder
    Future<List<Widget>> fetchDataFuture() async {
      for (DocumentSnapshot deliverDoc in snapshot.docs) {
        if (deliverDoc == null || !deliverDoc.exists) {
          continue; // Skip null or non-existing documents
        }

        String userid = deliverDoc.id;

        // Use await to get the result of StreamBuilder
        final contentSnapshot =
            await deliverDoc.reference.collection("Contents").get();

        if (contentSnapshot.docs.isNotEmpty) {
          // Process each document in the collection
          for (DocumentSnapshot contentDoc in contentSnapshot.docs) {
            if (contentDoc == null || !contentDoc.exists) {
              // Handle the case where a document is missing in the collection
              print("Document missing in collection for deliverDoc: $userid");
              // You may want to continue processing or take other actions
              continue;
            }

            final Map<String, dynamic> deliverUser =
                contentDoc.data() as Map<String, dynamic>;

            String docid = contentDoc.id;
            String name = deliverUser['name'];
            String title = deliverUser['title'];
            String imageLink = deliverUser['imageurl'];
            Timestamp timestamp = deliverUser["date"];
            String date = FormatDate.getdaytime(timestamp);
            String time = FormatDate.date(deliverUser["date"]);
            String duration = deliverUser['duration'];
            String dayDuration = duration.split("วัน")[0];
            final parseDate = DateTime.parse(time);

            if (DateTime.now().difference(parseDate).inDays <=
                int.parse(dayDuration)) {
              // Add the widget to the list instead of returning it
              widgets.add(_showProfileDetail(
                userid: userid,
                name: name,
                imageLink: imageLink,
                title: title,
                date: date,
                docid: docid,
              ));
            }
          }
        } else {
          // Continue the loop if the collection is empty
          print("No Collection for deliverDoc: $userid");
        }
      }

      return widgets; // Return the list of widgets
    }

    return FutureBuilder(
      // Use the Future returned by fetchDataFuture
      future: fetchDataFuture(),
      builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
        // Check if snapshot has data and is not null
        if (snapshot == null || !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Filter out null values before returning the combined widgets
        List<Widget> filteredWidgets =
            snapshot.data?.whereType<Widget>().toList() ?? [];
        if (filteredWidgets.isEmpty) {
          // If no matching documents are found in the collection
          return Center(
            child: Text("No data"),
          );
        }

        // Return the combined widgets for all documents
        return ListView(children: filteredWidgets);
      },
    );
  }

  Widget _showProfileDetail({
    required String userid,
    required String name,
    required String imageLink,
    required String title,
    required String date,
    required String docid,
  }) {
    return StreamBuilder(
        stream: _firestore.collection("Profile").doc(userid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          Map<String, dynamic> data = {};

          if (snapshot.hasData && snapshot.data!.exists) {
            final profileData = snapshot.data!.data();
            if (profileData != null) {
              data = profileData;
              String imagelinkprofile = data["imageLink"] ?? "";
              return Card(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: imagelinkprofile != ""
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              imagelinkprofile,
                                              scale: 0.8),
                                          maxRadius: 20.0,
                                        )
                                      : Image(
                                          image: NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                              scale: 0.8),
                                          width: 40.0,
                                        ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 20.0, right: 30),
                                  child: Text("${name}"),
                                ),
                                Text("${date}"),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                _showProfileDialog(context, userid);
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ),
                      Text("${title}"),
                      SizedBox(
                        height: 15,
                      ),
                      imageLink != ""
                          ? Image(
                              image: NetworkImage(
                                imageLink,
                              ),
                              width: 400,
                            )
                          : Image(
                              image: NetworkImage(
                                "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                              ),
                              width: 40.0,
                            ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              ShowCommentBottm(
                                  context, saveComment, docid, uid);
                            },
                            child: Text('ความคิดเห็น'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return Container(
            child: Text(
              "ไม่มีรายการในวันนี้",
              style: TextStyle(color: Colors.red),
            ),
          );
        });
  }
}

Future ShowCommentBottm(
    context, Function saveComment, String postId, String uid) {
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
                          hintText: "แสดงความคิดเห็น",
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

StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> _showDiaslogProfile(
  BuildContext context,
  String uid,
) {
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: _firestore.collection('Profile').doc(uid).snapshots(),
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
  if (userData != {}) {
    String image = userData['imageLink'] ?? '';
    return AlertDialog(
      title: CircleAvatar(
        backgroundImage: NetworkImage(
          image,
          scale: 0.8,
        ),
        maxRadius: 80.00,
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

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("No data"),
      ),
    );
  }
}
