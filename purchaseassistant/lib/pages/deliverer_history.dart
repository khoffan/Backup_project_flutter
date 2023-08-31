import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/utils/delivers_services.dart';

import 'deliverer_screen.dart';

class DeliverHistory extends StatefulWidget {
  const DeliverHistory({super.key});

  @override
  State<DeliverHistory> createState() => _DeliverHistoryState();
}

class _DeliverHistoryState extends State<DeliverHistory> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";

  @override
  void initState(){
    super.initState();
    uid = _auth.currentUser!.uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Posted"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              onPressed: () {
                Navigator.pop(context);
                ServiceDeliver().updateStatus(false, uid);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DelivererScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('deliverPost').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Container(
              alignment: Alignment.center,
              child: Text(snapshot.error.toString()),
            );
          }
          if(!snapshot.hasData){
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          final deliverDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: deliverDocs.length,
            itemBuilder: (context, index) {
            return Container();
          },);
        },
      ),
    );
  }
}
