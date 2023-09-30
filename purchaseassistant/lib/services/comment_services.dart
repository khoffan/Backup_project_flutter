
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_services.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ServiceComment {
  Future<void> saveDeliverComment({
    required String uid,
    required String postId,
    required String title,
  }) async {
    try {
      // Get user profile data
      DocumentSnapshot<Map<String, dynamic>> getProfilesnapshot =
          await AddProfile().getDataProfile();

      // Get user status

      if (getProfilesnapshot.exists) {
        Map<String, dynamic> data =
            getProfilesnapshot.data() as Map<String, dynamic>;

        String name = data['name'] ?? '';
        String lname = data['lname'] ?? '';
        String stdid = data['stdid'] ?? '';

        // Use serverTimestamp for consistency
        FieldValue timestamp = FieldValue.serverTimestamp();

        // Update user status
        // final contentDeliver = await _firestore.collection('deliverPost').doc(uid).collection('deliverContent').get();


        // Add comment to user's comments subcollection
        final deliverRef = _firestore.collection('Comments');
        await deliverRef.add({
          'userid': uid,
          'postId': postId,
          'name': name,
          'lastname': lname,
          'stdid': stdid,
          'title': title,
          'date': timestamp,
        });

        print('Comment saved successfully');
      }
    } catch (e) {
      // Print detailed error information
      print('Error: $e');
      throw e;
    }
  }
}
