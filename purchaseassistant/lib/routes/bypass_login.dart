import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/auth/login_screen.dart';

import '../services/auth_service.dart';

class BypassLogin extends StatelessWidget {
  const BypassLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.amber,
      child: ElevatedButton(
          onPressed: () async {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          child: Text("by pass login Out")),
    );
  }
}
