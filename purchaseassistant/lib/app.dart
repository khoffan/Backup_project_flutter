import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchaseassistant/pages/auth/login_screen.dart';
import 'package:purchaseassistant/routes/routes.dart';
import 'Provider/deliverDataProvider.dart';

import 'routes/checkLogin.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DeliveryDataProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoute.all,
        home: const LoginScreen(),
      ),
    );
  }
}
