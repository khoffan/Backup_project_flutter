import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchaseassistant/pages/auth/login_screen.dart';
import 'package:purchaseassistant/services/auth_service.dart';
import 'package:purchaseassistant/services/user_provider.dart';

import '../widgets/custom_navigation_bar.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  Future checklogin() async {
    bool? login = await UserLogin.getLogin();
    if (login == false) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else if(login == true){
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => BottomNavigation()));
    } else {
      Container(
        child: ElevatedButton(onPressed: () async{
          await AuthServices().Signoutuser(context);
        }, child: Text("by pass sign Out")),
      );
    }
  }
  void initState(){
    super.initState();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
