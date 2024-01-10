import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:purchaseassistant/services/auth_service.dart';
import 'package:purchaseassistant/services/delivers_services.dart';
import 'package:purchaseassistant/services/profile_services.dart';
import 'package:purchaseassistant/services/user_provider.dart';
import '../../models/login.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final formKey = GlobalKey<FormState>();
  Login login = Login();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: themeBg,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 10.0,
                ),
                child: ListView(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 280,
                      width: 280,
                      fit: BoxFit.scaleDown,
                    ),
                    const Center(
                      child: Text(
                        "Login now",
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        "please enter the details below to continue",
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(190, 255, 255, 255),

                                // icon: Icon(Icons.person),
                                hintText: 'Email',
                                border: OutlineInputBorder(),
                                labelText: "Username",
                              ),
                              onSaved: (String? username) {
                                login.email = username;
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "กรุณาใส่ Username";
                                } else if (!EmailValidator.validate(value)) {
                                  return "กรุณากรอก Email ให้ถูกต้อง";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 15.0),
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(190, 255, 255, 255),
                                // icon: Icon(Icons.person),
                                hintText: 'Password',
                                border: OutlineInputBorder(),
                                labelText: "Password",
                              ),
                              onSaved: (String? password) {
                                login.password = password;
                              },
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'กรุณาใส่รหัสผ่าน'
                                    : null;
                              },
                            ),
                            const Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 15.0)),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     top: 10.0,
                            //     bottom: 15.0,
                            //   ),
                            //   // child: Align(
                            //   //   alignment: Alignment.centerLeft,
                            //   //   child: InkWell(
                            //   //     onTap: () {},
                            //   //     child: const Text(
                            //   //       "Forgot password",
                            //   //       style: TextStyle(
                            //   //         color: Color(0xFFDA3340),
                            //   //       ),
                            //   //     ),
                            //   //   ),
                            //   // ),
                            // ),
                            Container(
                              height: 40.0,
                              width: 160,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // <-- Radius
                                    ),
                                    backgroundColor: Colors.green,
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState?.save();
                                      try {
                                        bool? sts;
                                        await AuthServices()
                                            .SigninwithEmailandPassword(
                                                login.email, login.password);
                                        formKey.currentState?.reset();
                                        Navigator.pushReplacementNamed(context,
                                            AppRoute.widget_navigation);

                                        ProfileService().updateRole(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            "customer");
                                        UserLogin.setLogin(true);
                                        sts = await UserLogin.getLogin();
                                        ServiceDeliver().updateUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            sts);
                                      } on FirebaseException catch (e) {
                                        print("ecode: ${e.code}");
                                        String message = "";
                                        if (e.code == "wrong-password" ||
                                            e.code == "user-not-found") {
                                          message =
                                              "username หรือ password ไม่ถูกต้อง";
                                        }
                                        Fluttertoast.showToast(
                                            msg: message,
                                            gravity: ToastGravity.CENTER);
                                      }
                                    }
                                  },
                                  child: Text("Login")),
                            ),
                          ],
                        )),

                    // const SizedBox(height: 20.0),
                    // Register button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoute.register);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
