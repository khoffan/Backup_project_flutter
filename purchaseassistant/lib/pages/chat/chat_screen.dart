import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/chat/order_tracker.dart';
import 'package:purchaseassistant/routes/routes.dart';
import 'package:purchaseassistant/services/chat_services.dart';
import 'package:intl/intl.dart';
import 'package:purchaseassistant/services/matching_services.dart';
import 'package:purchaseassistant/services/profile_services.dart';
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
  late StreamSubscription<bool>? _stremSub;
  String uid = "";
  String? otherid;
  String anotherid = "";
  bool isRiderStatus = true;
  Timestamp? _lastMessageTimestamp;
  FocusNode _focusNode = FocusNode();
  String chatroomid = "";
  bool isShowIcon = false;

  void sendMessge() async {
    if (_messageController.text.isNotEmpty) {
      await ChatServices().sendMessge(otherid!, _messageController.text);

      _messageController.clear();
    }
  }

  void setChatuserData() async {
    bool isChecking = await APIMatiching().checkCusidandRiderid(uid, otherid!);
    Map<String, dynamic> riderdata = {};
    Map<String, dynamic> cusdata = {};
    if (isChecking) {
      final cusprofileData = await ProfileService().getDataProfile(uid);
      final String name = cusprofileData["name"];
      final String lname = cusprofileData["lname"];
      final String phone = cusprofileData["phone"];

      cusdata = {
        "cusid": uid,
        "cusname": name,
        "cussurname": lname,
        "cusphone": phone,
        "date": Timestamp.now()
      };

      final riderprofileData = await ProfileService().getDataProfile(otherid!);
      final String ridername = riderprofileData["name"];
      final String ridersurname = riderprofileData["lname"];
      final String riderphone = riderprofileData["phone"];

      riderdata = {
        "riderid": otherid,
        "ridername": ridername,
        "ridersurname": ridersurname,
        "riderphone": riderphone,
        "date": Timestamp.now()
      };

      await ChatServices().setChatroomData(uid, otherid!, cusdata, riderdata);
    }
  }

  void closeChatState(String id) async {
    try {
      anotherid = await APIMatiching().getRiderid(id);
      if (uid.trim() == anotherid.trim()) {
        APIMatiching().updateRiderData(id);
        APIMatiching().updateStatusChatCustomer(id);
        Navigator.pop(context);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  void checkStatusrider() async {
    try {
      _stremSub = APIMatiching().getRiderStatus(uid).listen(
        (bool isStatus) {
          setState(() {
            isRiderStatus = isStatus;
          });
          print(isRiderStatus);
          if (isRiderStatus == false) {
            Navigator.pop(context);
          }
        },
        onError: (dynamic e) {
          print(e.toString());
        },
        onDone: () {
          print("Strem is clise");
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void getChatroomid(String currid, String revicedid) async {
    try {
      String docid = await ChatServices().getChatRoomid(currid, revicedid);
      setState(() {
        chatroomid = docid;
      });
      print(chatroomid);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    otherid = widget.reciveuid ?? '';
    _focusNode.addListener(() {
      setState(() {
        isShowIcon = !_focusNode.hasFocus;
      });
    });
    if (uid != anotherid) {
      checkStatusrider();
    }
    setChatuserData();
    if (mounted) {
      getChatroomid(uid, otherid!);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _stremSub?.cancel();
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
        leading: IconButton(
            onPressed: () {
              closeChatState(otherid!);
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  maximumSize: Size(100, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none, // <-- Radius
                  ),
                  minimumSize: Size(30, 2),
                  backgroundColor: Colors.white38),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderTrackers(chatroomid: chatroomid),
                  ),
                );
                print(chatroomid);
                ChatServices().setTrackingState(chatroomid);
              },
              child: Text(
                "คำสั่งซื้อ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
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
      stream: ChatServices().getMessage(uid, otherid!),
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

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: chatDocs
                .map(
                  (document) => _bulidMessageItem(document),
                )
                .toList(),
          ),
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (data['senderId'] == _auth.currentUser!.uid)
                      ? Colors.blue
                      : Colors.grey,
                ),
                child: Text(
                  data['message'],
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
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
                  hintText: "ส่งข้อความ...",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send), // You can choose any icon you like.
                    onPressed: () {
                      sendMessge();
                      _messageController.clear();
                      // FocusScope.of(context).unfocus();
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
