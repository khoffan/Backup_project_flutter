import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/chat/order_tracker.dart';
import 'package:purchaseassistant/routes/routes.dart';
import 'package:purchaseassistant/services/chat_services.dart';
import 'package:intl/intl.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/utils/constants.dart';
import '../../utils/ChatBouble.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    super.key,
    required this.reciveuid,
    required this.name,
  });

  String? reciveuid;
  String? name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = "";
  String otherid = "";
  Timestamp? _lastMessageTimestamp;
  FocusNode _focusNode = FocusNode();
  bool isShowIcon = true;

  void sendMessge() async {
    if (_messageController.text.isNotEmpty) {
      print(otherid);
      await ChatServices().sendMessge(otherid, _messageController.text);
      _messageController.clear();
    }
  }

  void closeChatState() async {
    try {
      String id = await APIMatiching().getRiderid(otherid);
      print("is id: ${id} and uid is: ${uid}");
      if (uid.trim() != id.trim()) {
        APIMatiching().updateStatusRider(otherid);
        Navigator.pop(context);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    otherid = widget.reciveuid ?? '';
    print(otherid);
    _focusNode.addListener(() {
      setState(() {
        isShowIcon = !_focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.name}",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: themeBg,
        leading: null,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderTrackers(),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput()
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: ChatServices().getMessage(uid, otherid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = snapshot.data!.docs;

        return ListView(
          children: snapshot.data!.docs
              .map(
                (document) => _bulidMessageItem(document),
              )
              .toList(),
        );
      },
    );
  }

  Widget _bulidMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var aliment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.bottomLeft;

    Timestamp timestamp =
        data['timestamp']; // Assuming your timestamp field is named 'timestamp'
    DateTime dateTime =
        timestamp.toDate(); // Convert Firestore Timestamp to DateTime

    bool showTime = false;
    if (_lastMessageTimestamp == null ||
        dateTime.difference(_lastMessageTimestamp!.toDate()).inMinutes >= 15) {
      showTime = true;
      _lastMessageTimestamp = timestamp;
    }

    return Container(
      alignment: aliment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (showTime)
              Center(
                child: Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(dateTime),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            if (data['message'] != null &&
                data['message'].toString().isNotEmpty)
              ChatBouble(message: data['message'])
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(96, 216, 216, 216),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onTap: () {
                  setState(() {
                    isShowIcon = false;
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    isShowIcon = true;
                  });
                },
                focusNode: _focusNode,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Enter message",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send), // You can choose any icon you like.
                    onPressed: () {
                      sendMessge();
                      _messageController.clear();
                    },
                  ),
                  prefixIcon: isShowIcon
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person), // First icon
                            SizedBox(width: 8), // Add spacing between icons
                            Icon(Icons.location_on), // Second icon
                          ],
                        )
                      : null,
                ),
                controller: _messageController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
