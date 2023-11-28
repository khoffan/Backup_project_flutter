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
      MatchList matchList = MatchList.fromJson(jsonMap);
      for (Match match in matchList.matches) {
        datamatch.cusId = match.customerid;
        datamatch.cusName = match.customername;
        datamatch.riderId = match.riderid;
        datamatch.riderName = match.ridername;
        datamatch.date = match.date;
        print("cusid: ${match.customerid}");
        print("cusname: ${match.customername}");
        print("riderid: ${match.riderid}");
        print("ridername: ${match.ridername}");
      }
      setState(() {});
    } else {
      print("data not found");
    }
  }

  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
    data = json.encode(widget.response);
    print("Loading_page: ${widget.response}");
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
            datamatch.cusId != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: 20,),
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
                : ElevatedButton(
                    onPressed: () {
                      if (widget.response != null) {
                        getDataAPI();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Back to Home"),
                  ),
          ],
        ),
      ),
    );
  }
}
