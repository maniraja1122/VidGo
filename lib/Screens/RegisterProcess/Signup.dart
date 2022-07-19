import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socialframe/Models/User.dart';
import 'package:socialframe/Repository/AuthHelper.dart';
import 'package:socialframe/Repository/DBHelper.dart';
import 'package:socialframe/Widgets/RoundButton.dart';

import '../../Routes.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var name = "";

  var email = "";

  var password = "";
  var showbar=false;
  var fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Sign Up",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Create an account. It's free"),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.length < 6) {
                          return "Please enter a long name (atleast 6 chars)";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        name = val;
                      },
                      decoration: InputDecoration(
                          hintText: "Enter Name", label: Text("Name")),
                    ),
                    SizedBox(
                      height: 5,
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
                        text: "Register",
                        bacground: Colors.blue,
                        foreground: Colors.white,
                        onPressed: () async {
                          if (fkey.currentState!.validate()) {
                              setState((){
                                showbar=true;
                              });
                              try {
                                final res = await DBHelper.auth
                                    .createUserWithEmailAndPassword(
                                    email: email, password: password);
                                if (res.user != null) {
                                  var newuser = Users(key: res.user!.uid,
                                      Name: name,
                                      Email: email,
                                      Password: password);
                                  await DBHelper.db.collection("Users").add(newuser.toMap());
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
                        Text("Already have an account? "),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.Login);
                          },
                          child: Text(
                            "Log In",
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
