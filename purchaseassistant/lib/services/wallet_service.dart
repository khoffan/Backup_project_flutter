import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceWallet {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<double> getTotalAmount(String uid) async* {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("Profile").doc(uid).get();
      CollectionReference subCollection =
          snapshot.reference.collection("transaction");

      StreamController<double> controller = StreamController<double>();

      subCollection.orderBy("timeStamp", descending: true).snapshots().listen(
        (QuerySnapshot subData) {
          if (subData.docs.isNotEmpty) {
            final data = subData.docs.first.data() as Map<String, dynamic>;
            double totalAmount = data["totalAmount"] ?? 0.00;

            // Emit the total amount through the stream
            controller.add(totalAmount);
          } else {
            // Emit a default value if subcollection is empty
            controller.add(0.00);
          }
        },
        onError: (dynamic error) {
          // Handle errors and close the stream if needed
          controller.addError(error);
        },
        onDone: () {
          // Close the stream when the subscription is done
          controller.close();
        },
      );

      yield* controller.stream;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> setExchangeAmount(
      String uid, double dischange, double totalAmount) async {
    try {
      await _firestore
          .collection("Profile")
          .doc(uid)
          .collection("transaction")
          .add({
        'totalAmount': totalAmount - dischange,
        'amount': dischange,
        'option': 'exchange',
        'timeStamp': DateTime.timestamp()
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
