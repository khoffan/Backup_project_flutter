import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  final String text = 'por';
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBg,
        title: const Text(
          'Purchase Assistant',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
            color: Colors.amber[800],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.amber[800],
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: IconButton(
            color: Colors.amber[800],
            icon: const Icon(Icons.sensor_occupied_rounded),
            onPressed: () {},
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Index 0: Home',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
