/// Order Tracker Zen
///
/// A Flutter package that provides a simple and customizable order tracking widget for your applications.
/// This example demonstrates how to create an order tracking widget using the OrderTrackerZen package.
///
/// To use this package, add `order_tracker_zen` as a dependency in your `pubspec.yaml` file.
import 'package:flutter/material.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:purchaseassistant/utils/constants.dart';

/// The main function is the entry point of the application.

/// OrderTracker is a StatelessWidget that acts as the root widget of the application.
///
/// It configures the MaterialApp with the necessary theme and routing information.
class OrderTrackers extends StatefulWidget {
  const OrderTrackers({Key? key}) : super(key: key);

  @override
  State<OrderTrackers> createState() => _OrderTrackersState();
}

class _OrderTrackersState extends State<OrderTrackers> {
  bool isFalse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ติดตามสถานะคำสั่งซื้อ",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: themeBg,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add padding around the OrderTrackersZen widget for better presentation.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              // OrderTrackerZen is the main widget of the package which displays the order tracking information.
              child: OrderTrackerZen(
                text_primary_color: Colors.amber,
                success_color: Colors.cyan,
                isShrinked: false,
                screen_background_color: themeBg,
                // Provide an array of TrackerData objects to display the order tracking information.
                tracker_data: [
                  // TrackerData represents a single step in the order tracking process.
                  TrackerData(
                    title: "Order Placed",
                    date: "Sat, 8 Apr '22",
                    tracker_details: [
                      isFalse
                          ? TrackerDetails(
                              title: "Your order was placed on Zenzzen1",
                              datetime: "Sat, 8 Apr '22 - 17:17",
                            )
                          : TrackerDetails(
                              title: "Your order was placed on Zenzzen2",
                              datetime: "Sat, 8 Apr '22 - 17:42",
                            ),
                      TrackerDetails(
                        title: "Zenzzen Arranged A Callback Request",
                        datetime: "Sat, 8 Apr '22 - 17:42",
                      ),
                    ],
                  ),
                  // yet another TrackerData object
                  TrackerData(
                    title: "Order Shipped",
                    date: "Sat, 8 Apr '22",
                    tracker_details: [
                      TrackerDetails(
                        title: "Your order was shipped with MailDeli",
                        datetime: "Sat, 8 Apr '22 - 17:50",
                      ),
                    ],
                  ),
                  // And yet another TrackerData object
                  TrackerData(
                    title: "Order Delivered",
                    date: "Sat,8 Apr '22",
                    tracker_details: [
                      TrackerDetails(
                        title: "You received your order, by MailDeli",
                        datetime: "Sat, 8 Apr '22 - 17:51",
                      ),
                    ],
                  ),

                  TrackerData(
                    title: "Anathor order",
                    date: "now",
                    tracker_details: [
                      TrackerDetails(
                        title: "new order",
                        datetime: "next day",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
