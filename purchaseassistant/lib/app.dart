import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/auth/login_screen.dart';
import 'package:purchaseassistant/routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: AppRoute.all,
      home: const LoginScreen(),
    );
  }
}
