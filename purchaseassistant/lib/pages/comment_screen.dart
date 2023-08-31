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
      stream: _firestore
          .collection('deliverPost')
          .doc(widget.uid) // Use the specified post ID
          .collection('comments')
          .snapshots(),
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
            String commentUser = commentData['user'] ?? '';
            String commentid = commentData['postId'] ?? '';
            print("comment: ${commentid}");
            print("comment: ${widget.postId}");
            if (commentid == widget.postId) {
              return ListTile(
                title: Text(commentUser),
                subtitle: Text(commentText),
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
