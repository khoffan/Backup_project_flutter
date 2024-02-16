import 'package:flutter/material.dart';

class EventCards extends StatelessWidget {
  final child;
  final bool isPart;
  const EventCards({super.key, required this.isPart, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isPart ? Colors.green : Colors.grey,
      ),
      child: child,
    );
  }
}
