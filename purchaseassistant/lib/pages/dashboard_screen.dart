import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/posted/show_post.dart';
import '../services/auth_service.dart';
import '../services/user_provider.dart';
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
  void bypasssignout() {
    ElevatedButton(
      onPressed: () async {
        await AuthServices().Signoutuser(context);
        // await UserLogin.setLogin(false);
        // Add Logout here
      },
      child: const Text("Sign Out"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeBg,
        title: const Text(
          'Purchase Assistant',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.amber[800],
          ),
        ],
      ),
      body: ShowPost(),
    );
  }
}
