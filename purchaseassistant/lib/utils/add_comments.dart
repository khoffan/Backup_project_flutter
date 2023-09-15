import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/utils/delivers_services.dart';

class Addcomment extends StatefulWidget {
  const Addcomment({super.key});

  @override
  State<Addcomment> createState() => _AddcommentState();
}

class _AddcommentState extends State<Addcomment> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _commentController = TextEditingController();
  String uid = "";

  // void saveComment() async {
  //   try {
  //     String comment = _commentController.text;

  //     await ServiceDeliver().saveDeliverComment(uid: uid, title: comment, postId: );
  //     _commentController.clear();
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("addcomments"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty && value == null) {
                        return "กรุณาใส่ข้อมูล";
                      }
                      return null;
                    },
                    controller: _commentController,
                  )),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // saveComment();
                  }
                },
                child: Text("comment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
