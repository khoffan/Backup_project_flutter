import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/chat/chat_screen.dart';
import 'package:purchaseassistant/utils/formatDate.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({super.key, required this.postId, required this.uid});

  String postId = "";
  String uid = "";

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> popupItems = ["เข้าสู่ช่องฃแชท", "ตอบกลับ", "รายงาน"];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('Comments').snapshots(),
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

        final commentDocs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: commentDocs.length,
          itemBuilder: (context, index) {
            final commentDoc = commentDocs[index];
            final commentData = commentDoc.data() as Map<String, dynamic>;
            String commentText = commentData['title'] ?? '';
            String commentUser = commentData['name'] ?? '';
            String commentid = commentData['postId'] ?? '';
            String userId = commentData['userid'] ?? '';
            String date = FormatDate(commentData['date']);
            print("comment: ${commentid}");
            print("userId: ${userId}");
            print("commentUser: ${commentUser}");
            print("posatid: ${widget.postId}");
            if (commentid == widget.postId) {
              return Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 350, // Increase the width if necessary
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ListTile(
                                        title: Text(commentUser),
                                        subtitle: Text(commentText),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildMediaBottom(context, userId, commentUser),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("${date}"),
                                Text("ถูกใจ"),
                                Text("ตอบกลับ"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }

  Widget _buildMediaBottom(context, String uid, String name) {
    return Center(
      child: PopupMenuButton<String>(
        itemBuilder: (context) {
          return popupItems.map(
            (item) {
              return PopupMenuItem<String>(
                child: Text(item),
                value: item,
              );
            },
          ).toList();
        },
        onSelected: (String value) {
          // Handle the selected menu item here
          _handleMenuItemTap(value, uid, name);
        },
      ),
    );
  }

  void _handleMenuItemTap(String selectedItem, String uid, String name) {
    // Implement your logic for handling the selected item here
    if (selectedItem == "เข้าสู่ช่องฃแชท") {
      if (uid != _auth.currentUser!.uid) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(reciveuid: uid, name: name),
          ),
        );
      } else {
        Dialog(
          child: Text("user is connnecting"),
        );
      }
    } else if (selectedItem == "ตอบกลับ") {
      // Handle the "ตอบกลับ" action
    } else if (selectedItem == "รายงาน") {
      // Handle the "รายงาน" action
    }
  }
}
