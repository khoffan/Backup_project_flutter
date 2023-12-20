import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/services/chat_services.dart';
import 'package:purchaseassistant/utils/constants.dart';

import 'chat_screen.dart';

class ListUserchat extends StatefulWidget {
  const ListUserchat({super.key});

  @override
  State<ListUserchat> createState() => _ListUserchatState();
}

class _ListUserchatState extends State<ListUserchat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แชต",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: themeBg,
      ),
      body: _buildShowUser(),
    );
  }

  Widget _buildShowUser() {
    return StreamBuilder(
      stream: _firestore.collection('userProfile').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((docs) => _listUser(docs)).toList(),
        );
      },
    );
  }

  Widget _listUser(DocumentSnapshot docs) {
    Map<String, dynamic> data = docs.data() as Map<String, dynamic>;

    return StreamBuilder(
      stream: _firestore
          .collection('chat_rooms')
          .where('recivesid', isEqualTo: docs.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatroomid = snapshot.data!.docs;

        // Ensure data exists before accessing its properties
        if (data.containsKey('imageLink') && data.containsKey('name')) {
          return Card(
            child: InkWell(
              child: SizedBox(
                width: 100,
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(data["imageLink"]),
                    ),
                    Text(data['name']),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChatScreen(reciveuid: docs.id, name: data['name']),
                  ),
                );
              },
            ),
          );
        } else {
          // Handle the case where the data is missing or incomplete
          return Container();
        }
      },
    );
  }

  Widget _getUserChat() {
    return StreamBuilder(
      stream: _firestore.collection('chat_rooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatDoc = chatDocs[index];
              print(chatDoc);
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _ChatUserlist(DocumentSnapshot documents) {
    Map<String, dynamic> data = documents.data() as Map<String, dynamic>;
    print(documents.id);
    return Container();
  }
}
