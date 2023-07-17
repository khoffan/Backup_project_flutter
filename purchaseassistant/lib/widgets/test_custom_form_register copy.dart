import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../backend/register.dart';
import '../pages/login_screen.dart';

class CustomFormRegister extends StatelessWidget {
  const CustomFormRegister({
    super.key,
    required this.formKey,
    required this.register,
  });

  final GlobalKey<FormState> formKey;
  final Register register;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 5.0,
          ),
          child: ListView(
            children: [
              // Image.asset(
              //   "assets/logo.png",
              //   height: 250,
              //   width: 250,
              //   fit: BoxFit.cover,
              // ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 30.0,
                  bottom: 2.0,
                ),
                child: Text(
                  "Register now",
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Text("please enter the details below to continue"),
              const SizedBox(
                height: 20.0,
              ),

              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // TextFormField(
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: const InputDecoration(
                      //     filled: true,
                      //     fillColor: Color.fromARGB(190, 255, 255, 255),

                      //     // icon: Icon(Icons.person),
                      //     hintText: 'Username',
                      //     border: OutlineInputBorder(),
                      //     labelText: "Username",
                      //   ),
                      //   onSaved: (String? username) {
                      //     register.username = username;
                      //   },
                      //   validator: (String? value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "กรุณาใส่ Username";
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      // ),
                      // const SizedBox(height: 8.0),
                      // TextFormField(
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: const InputDecoration(
                      //     filled: true,
                      //     fillColor: Color.fromARGB(190, 255, 255, 255),

                      //     // icon: Icon(Icons.person),
                      //     hintText: 'StudentID',
                      //     border: OutlineInputBorder(),
                      //     labelText: "StudentID",
                      //   ),
                      //   onSaved: (String? studentID) {
                      //     register.studentID = studentID;
                      //   },
                      //   validator: (String? value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "กรุณาใส่ StudentID";
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      // ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(190, 255, 255, 255),

                          // icon: Icon(Icons.person),
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                        onSaved: (String? password) {
                          register.password = password;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณาใส่ Password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      // const SizedBox(height: 8.0),
                      // TextFormField(
                      //   obscureText: true,
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: const InputDecoration(
                      //     filled: true,
                      //     fillColor: Color.fromARGB(190, 255, 255, 255),

                      //     // icon: Icon(Icons.person),
                      //     hintText: 'ConfirmPassword',
                      //     border: OutlineInputBorder(),
                      //     labelText: "ConfirmPassword",
                      //   ),
                      //   onSaved: (String? confirmPassword) {
                      //     register.confirmPassword = confirmPassword;
                      //   },
                      //   validator: (String? value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "กรุณาใส่ Password";
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      // ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(190, 255, 255, 255),

                          // icon: Icon(Icons.person),
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        onSaved: (String? email) {
                          register.email = email;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "กรุณาใส่ Email";
                          } else if (!value.contains('@')) {
                            return "กรุณากรอก Email ให้ถูกต้อง";
                          } else {
                            return null;
                          }
                        },
                      ),
                      // const SizedBox(height: 8.0),
                      // TextFormField(
                      //   keyboardType: TextInputType.emailAddress,
                      //   decoration: const InputDecoration(
                      //     filled: true,
                      //     fillColor: Color.fromARGB(190, 255, 255, 255),

                      //     // icon: Icon(Icons.person),
                      //     hintText: 'Phone',
                      //     border: OutlineInputBorder(),
                      //     labelText: "Phone",
                      //   ),
                      //   onSaved: (String? phone) {
                      //     register.phone = phone;
                      //   },
                      //   validator: (String? value) {
                      //     if (value == null || value.isEmpty) {
                      //       return "กรุณาใส่เบอร์โทรศัพท์";
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      // ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 40.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // <-- Radius
                              ),
                              backgroundColor: Colors.red,
                              padding: const EdgeInsetsDirectional.symmetric(
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
                                      .createUserWithEmailAndPassword(
                                    email: register.email!,
                                    password: register.password!,
                                  );
                                  formKey.currentState?.reset();
                                } on FirebaseAuthException catch (e) {
                                  print(e.message);
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
