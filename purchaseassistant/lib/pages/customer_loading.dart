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
  List<DataMatch> datamatches = [];

  void getDataAPI() {
    if (data.isNotEmpty) {
      print("data: ${data}");
      List<dynamic> jsonList = json.decode(data);
      MatchList matchList = MatchList.fromJson(jsonList);

      List<DataMatch> dataMatches = [];

      for (Match match in matchList.matches) {
        DataMatch matchData = DataMatch(
          cusId: match.customerid,
          cusName: match.customername,
          riderId: match.riderid,
          riderName: match.ridername,
          date: match.date,
        );

        dataMatches.add(matchData);
      }

      setState(() {
        datamatches = dataMatches;
        data = "";
      });
    } else {
      print("data not found");
      // Navigator.pop(context);
    }
  }

  // void getRiderslistwithapi() async{
  //    await APIMatiching().getRiderlist("riderlist");
  // }

  @override
  void initState() {
    super.initState();
    data = json.encode(widget.response["matches"]);
    uid = _auth.currentUser!.uid;
    getDataAPI();
  }

  @override
  void dispose() {
    super.dispose();
    widget.response["matches"] = [];
    data = "";
    getDataAPI();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (DataMatch datamatch in datamatches)
              if (datamatch.cusId != null)
                Column(
                  // ... (your existing column properties)
                  children: [
                    Text(
                      "CustomerName : ${datamatch.cusName}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "RiderName : ${datamatch.riderName}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "Date : ${datamatch.date}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(alignment: Alignment.center),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("back to home"),
                      ),
                    )
                  ],
                )
              else
                Container(child: Text("match data is null "),),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back to Home",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
