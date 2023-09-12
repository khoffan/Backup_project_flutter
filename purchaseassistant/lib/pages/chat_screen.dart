import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/utils/chat_services.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.reciveuid, required this.name});

  String? reciveuid;
  String? name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";
  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatServices().getMessage(uid, widget.reciveuid ?? ''),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatRoomDocs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: chatRoomDocs.length,
          itemBuilder: (context, index) {
            final chatDoc = chatRoomDocs[index];
            final chatData = chatDoc.data() as Map<String, dynamic>;

            String message = chatData['message'];
            String name = chatData['name'];
            String sender =
                chatData['senderId']; // Assuming you have a 'sender' field

            // Here, you can customize the UI to display the chat message content.
            var aliment =
                (sender == uid) ? Alignment.centerRight : Alignment.bottomLeft;
            return Container(
              alignment: aliment,
              child: Column(
                crossAxisAlignment: (sender == uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: (sender == uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if(message != '' && message.isNotEmpty)
                    ListTile(
                      title: Text(name),
                      subtitle: Text(message),
                    )
                ],
              ), // Display the message content
            );
          },
        );
      },
    );
  }
}
