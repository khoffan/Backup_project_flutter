import 'package:flutter/material.dart';
import 'package:purchaseassistant/utils/event_card.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPart;
  final eventCard;
  const MyTimelineTile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPart,
      required this.eventCard});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        indicatorStyle: IndicatorStyle(
          color: isPart ? Colors.green : Colors.grey,
          width: 30,
          iconStyle: IconStyle(
              iconData: Icons.done, color: isPart ? Colors.green : Colors.grey),
        ),
        beforeLineStyle: LineStyle(color: isPart ? Colors.green : Colors.grey),
        endChild: EventCards(
          isPart: isPart,
          child: eventCard,
        ),
      ),
    );
  }
}
