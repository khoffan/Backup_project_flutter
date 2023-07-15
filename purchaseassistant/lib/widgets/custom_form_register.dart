import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../backend/register.dart';
import '../pages/login_screen.dart';

class CustomFormRegister extends StatefulWidget {
  const CustomFormRegister({
    super.key,
    required this.formKey,
    required this.register,
  });

  final GlobalKey<FormState> formKey;
  final Register register;

  @override
  State<CustomFormRegister> createState() => _CustomFormRegisterState();
}

class _CustomFormRegisterState extends State<CustomFormRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
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
                // padding: EdgeInsets.only(
                //   top: 4.0,
                //   bottom: 2.0,
                // ),
                child: Text(
                  "Register now",
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
                  key: widget.formKey,
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
                          widget.register.email = username;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณาใส่ Username";
                          } else if (!value.contains('@')) {
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
                          widget.register.password = password;
                        },
                        validator: (String? value) {
                          return (value == null || value.isEmpty)
                              ? 'กรุณาใส่รหัสผ่าน'
                              : null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 40.0,
                        width: 600,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // <-- Radius
                              ),
                              backgroundColor: Colors.red,
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 130,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (widget.formKey.currentState!.validate()) {
                                widget.formKey.currentState?.save();
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: widget.register.email!,
                                    password: widget.register.password!,
                                  );
                                  widget.formKey.currentState?.reset();
                                  if (context.mounted) {
                                    // Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return LoginScreen();
                                        },
                                      ),
                                    );
                                  }
                                  Fluttertoast.showToast(
                                    msg: "สร้างบัญชีผู้ใช้สำเร็จ",
                                    gravity: ToastGravity.CENTER,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  // print(e.code);
                                  // print(e.message);
                                  Fluttertoast.showToast(
                                      msg: e.message!,
                                      gravity: ToastGravity.CENTER);
                                }
                              }
                            },
                            child: const Text("Register")),
                      ),
                    ],
                  )),

              const Spacer(),

              // Register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Login",
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
}
