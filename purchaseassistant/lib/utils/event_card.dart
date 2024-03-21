import 'package:flutter/material.dart';

class EventCards extends StatelessWidget {
  final child;
  final bool isPart;
  EventCards({super.key, required this.isPart, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isPart ? Colors.green : Colors.grey,
      ),
      child: child,
    );
  }
}
