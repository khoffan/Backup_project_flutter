import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/login_screen.dart';
import 'package:purchaseassistant/pages/register_screen.dart';
import 'package:purchaseassistant/pages/testPage.dart';

import '../pages/service_screen.dart';
import '../widgets/custom_navigation_bar.dart';

class AppRoute {
  static const login = 'login';
  static const register = 'register';
  static const widget_navigation = 'navigation';
  static const service = 'service';
  static const test = 'test';

  static get all => <String, WidgetBuilder>{
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        widget_navigation: (context) => const BottomNavigation(),
        service: (context) => const ServiceScreen(),
        test: (context) => const TestPage(),
      };
}
