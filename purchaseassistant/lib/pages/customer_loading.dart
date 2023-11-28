import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/models/matchmodel.dart';
import 'package:purchaseassistant/services/matching_services.dart';

class CustomerLoadingScreen extends StatefulWidget {
  CustomerLoadingScreen({super.key, required this.response});
  Map<String, dynamic> response = {};
  @override
  State<CustomerLoadingScreen> createState() => _CustomerLoadingScreenState();
}

class _CustomerLoadingScreenState extends State<CustomerLoadingScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uid = "";
  String data = "";
  DataMatch datamatch = DataMatch();
  void getDataAPI() async {
    if (data != {}) {
      Map<String, dynamic> jsonMap = json.decode(data);
      MatchList matchList  = MatchList.fromJson(jsonMap);
      for (Match match in matchList.matches) {
        datamatch.cusId = match.customerid;
        datamatch.cusName = match.customername;
        datamatch.riderId = match.riderid;
        datamatch.riderName = match.ridername;
      }
    } else {
      return;
    }
  }

  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    data = json.encode(widget.response);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              "Loading",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.response != null) {
                  getDataAPI();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text("Back to Home"),
            ),
            SizedBox(
              height: 20,
            ),
            datamatch.cusId != null ? Column(
              children: [
                Text("CustomerId : ${datamatch.cusId}"),
                Text("CustomerName : ${datamatch.cusName}"),
                Text("RiderId : ${datamatch.riderId}"),
                Text("RiderName : ${datamatch.riderName}"),
              ],
            ) : Container()
              
          ],
        ),
      ),
    );

  }
  
}
