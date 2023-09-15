import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({super.key, required this.postId, required this.uid});

  String postId = "";
  String uid = "";

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            print("comment: ${commentid}");
            print("posatid: ${widget.postId}");
            if (commentid == widget.postId) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  alignment: Alignment.center,
                  width: 350, // Increase the width if necessary
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  title: Text(commentUser),
                                  subtitle: Text(commentText),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _buildMediaBottom(context);
                            },
                            icon: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("time"),
                          Text("ถูกใจ"),
                          Text("ตอบกลับ"),
                          
                        ],
                      )
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
}

Future _buildMediaBottom(context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        height: 200,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 10,
              ),
              _bulidMediaContent(context, "เข้าสู่ช่องฃแชท"),
              _bulidMediaContent(context, "ตอบกลับ"),
              _bulidMediaContent(context, "รายงาน"),
            ],
          ),
        ),
      );
    },
  );
}

GestureDetector _bulidMediaContent(context, String title) {
  if (title == "รายงาน") {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextButton(
          onPressed: () {},
          child: Text(
            title,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
  return GestureDetector(
    onTap: () {},
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
        ),
      ),
    ),
  );
}
