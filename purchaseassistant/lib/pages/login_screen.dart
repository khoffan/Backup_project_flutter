import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import '../models/login.dart';
import '../pages/home_screen.dart';
import '../utils/constants.dart';
import '../widgets/custom_navigation_bar.dart';
import './register_screen.dart';

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
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10.0,
                  ),
                  child: ListView(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        height: 200,
                        width: 200,
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
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 15.0,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Text(
                                      "Forgot password",
                                      style: TextStyle(
                                        color: Color(0xFFDA3340),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(),
                              SizedBox(
                                height: 40.0,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // <-- Radius
                                      ),
                                      backgroundColor: Colors.red,
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                        horizontal: 150,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState?.save();
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                            email: login.email!,
                                            password: login.password!,
                                          )
                                              .then((value) {
                                            formKey.currentState?.reset();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return BottomNavigation();
                                                },
                                              ),
                                            );
                                          });
                                        } on FirebaseException catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.message!,
                                              gravity: ToastGravity.CENTER);
                                        }
                                        //   print(
                                        //       "email = ${login.email} password = ${login.password}");
                                        //   formKey.currentState?.reset();
                                      }
                                    },
                                    child: const Text("Login")),
                              ),
                            ],
                          )),

                      // const SizedBox(height: 20.0),

                      const Spacer(),

                      // Register button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: themeError,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
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
