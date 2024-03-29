// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:purchaseassistant/pages/chat/chat_screen.dart';
// import 'package:purchaseassistant/services/matching_services.dart';
// import 'package:purchaseassistant/services/wallet_service.dart';
// import 'package:quickalert/quickalert.dart';

// class LoadingCustomerScreen extends StatefulWidget {
//   LoadingCustomerScreen({super.key, this.riderid});
//   String? riderid;
//   @override
//   State<LoadingCustomerScreen> createState() => _CustomerLoadingScreenState();
// }

// class _CustomerLoadingScreenState extends State<LoadingCustomerScreen> {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String uid = "";
//   String currid = "";
//   String reciveuid = "";
//   String name = "";
//   bool? isLoading;
//   late StreamSubscription<Map<String, dynamic>> streamData;

//   // _showAlert(String uid) {
//   //   if (mounted) {
//   //     QuickAlert.show(
//   //       context: context,
//   //       type: QuickAlertType.confirm,
//   //       title: "จับคู่สำเร็จ",
//   //       text: "คุณยอมรับการจับคู่หรือไม่",
//   //       confirmBtnText: 'ตกลง',
//   //       cancelBtnText: "ยกเลิก",
//   //       onConfirmBtnTap: () {
//   //         setState(() {
//   //           isLoading = true;
//   //         });
//   //         APIMatiching().updateStatusChatCustomer(uid);
//   //         APIMatiching().updateStatusCustomer(uid);
//   //         Navigator.pop(context);
//   //       },
//   //       confirmBtnColor: Colors.green,
//   //       onCancelBtnTap: () {
//   //         APIMatiching().updateStatusCustomer(uid);
//   //         Navigator.pop(context);
//   //       },
//   //     );
//   //   }
//   // }

//   _showAlertDelay() {
//     if (!mounted) {
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.confirm,
//         title: "ไม่พบผู้ให็บริการ",
//         text: "ไม่พบผู้บรืการ คูณต้องการที่จะจับคู่ใหม่หรือไม่",
//         confirmBtnText: 'ตกลง',
//         cancelBtnText: "ยกเลิก",
//         onConfirmBtnTap: () {
//           setState(() {
//             isLoading = false;
//           });
//         },
//         confirmBtnColor: Colors.green,
//         onCancelBtnTap: () {
//           APIMatiching().updateStatusCustomer(uid);
//           Navigator.pop(context);
//         },
//       );
//     }
//   }

//   void connectMatchingResult() {
//     try {
//       if (currid != "") {
//         streamData = APIMatiching().getData(currid).listen(
//           (Map<String, dynamic> snapshotData) {
//             if (snapshotData["rider_status"] == true && isLoading == false) {
//               name = snapshotData["ridername"];
//               reciveuid = snapshotData["riderid"];
//               if ((name, reciveuid) != "") {
//                 setState(() {
//                   isLoading = true;
//                 });

//                 APIMatiching().updateStatusChatCustomer(uid);
//                 APIMatiching().updateStatusCustomer(uid);
//               }
//               Future.delayed(Duration(seconds: 30), () {
//                 _showAlertDelay();
//               });
//             }
//           },
//           onError: (dynamic error) {
//             print("Error: ${error}");
//           },
//           onDone: () {
//             print("Stream is closed");
//           },
//         );
//       } else {
//         print("Document not updated");
//       }
//     } on FirebaseAuthException catch (e) {
//       print(e.message);
//     }
//   }

//   void updateStatusCustomer(String uid) async {
//     try {
//       await APIMatiching().updateStatusCustomer(uid);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   void initState() {
//     setState(() {
//       isLoading = false;
//     });
//     super.initState();
//     if (_auth.currentUser != null) {
//       uid = _auth.currentUser!.uid;
//       currid = widget.riderid ?? "";
//     } else {
//       print("User not authenticated");
//     }
//     connectMatchingResult();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     updateStatusCustomer(uid);
//     streamData.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading != true
//         ? Container(
//             color: Colors.white,
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircularProgressIndicator(),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "รอการจับคู่...",
//                   style: TextStyle(
//                       fontSize: 14, color: Colors.black, textBaseline: null),
//                 ),
//               ],
//             ),
//           )
//         : ChatScreen(reciveuid: reciveuid, name: name);
//   }
// }
