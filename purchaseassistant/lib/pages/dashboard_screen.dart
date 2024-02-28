import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/posted/show_post.dart';

import 'package:purchaseassistant/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: ShowPost());
  }
}
