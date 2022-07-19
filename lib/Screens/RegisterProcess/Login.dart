import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Models/User.dart';
import '../../Repository/AuthHelper.dart';
import '../../Repository/DBHelper.dart';
import '../../Routes.dart';
import '../../Widgets/RoundButton.dart';


class Login extends StatefulWidget {
const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = "";
  var password = "";
  var showbar=false;
  var fkey = GlobalKey<FormState>();
@override
Widget build(BuildContext context) {
return  Scaffold(
  body: SafeArea(
    child: ModalProgressHUD(
      inAsyncCall: showbar,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: fkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  "Log In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Welcome back to Social Frame"),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  validator: (val) {
                    if (!AuthHelper.isValidEmail(val!)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    email = val;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter Email", label: Text("Email")),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Please enter a long password (atleast 6)";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    password = val;
                  },
                  decoration: InputDecoration(
                      hintText: "Enter Password", label: Text("Password")),
                  obscureText: true,
                ),
                SizedBox(
                  height: 40,
                ),
                RoundButton(
                    text: "Log In",
                    bacground: Colors.blue,
                    foreground: Colors.white,
                    onPressed: () async {
                      if (fkey.currentState!.validate()) {
                        setState(() {
                          showbar = true;
                        });
                          try {
                            final res = await DBHelper.auth
                                .signInWithEmailAndPassword(
                                email: email, password: password);
                            if (res.user != null) {
                              setState(() {
                                showbar = false;
                              });
                              Navigator.pushNamed(context, Routes.Home);
                            }
                            else {
                              setState(() {
                                showbar = false;
                              });
                            }
                          } on FirebaseAuthException
                          catch(e){
                            setState(() {
                              showbar = false;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
                            });
                          }
                        }
                    }),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Do not have an account? "),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.Signup);
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
}
}
