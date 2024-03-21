import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:purchaseassistant/routes/routes.dart';
import 'package:purchaseassistant/services/auth_service.dart';
import '../models/login.dart';
import '../utils/constants.dart';

class CustomFormRegister extends StatefulWidget {
  const CustomFormRegister({
    super.key,
    required this.formKey,
    required this.register,
  });

  final GlobalKey<FormState> formKey;
  final Login register;

  @override
  State<CustomFormRegister> createState() => _CustomFormRegisterState();
}

class _CustomFormRegisterState extends State<CustomFormRegister> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: themeBg,
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // <-- Radius
                          ),
                          backgroundColor: Colors.green,
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 40,
                            vertical: 8,
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
                              if (widget.register.email != "" &&
                                  widget.register.password != "") {
                                await AuthServices().registerEmailandPassword(
                                    widget.register.email!,
                                    widget.register.password!);
                              }
                              widget.formKey.currentState?.reset();
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, AppRoute.login);
                              }
                              Fluttertoast.showToast(
                                msg: "สร้างบัญชีผู้ใช้สำเร็จ",
                                gravity: ToastGravity.CENTER,
                              );
                            } on FirebaseAuthException catch (e) {
                              String message = '';
                              if (e.code == 'email-already-in-use') {
                                message = 'มีชื่อบัญชีผู้ใช้นี้แล้ว';
                              } else if (e.code == 'weak-password') {
                                message =
                                    'รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป';
                              } else {
                                message = e.message!;
                              }
                              Fluttertoast.showToast(
                                  msg: message, gravity: ToastGravity.CENTER);
                            }
                          }
                        },
                        child: const Text("Register")),
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
                    Navigator.pushNamed(context, AppRoute.login);
                  },
                  child: Text(
                    "Login",
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
}
