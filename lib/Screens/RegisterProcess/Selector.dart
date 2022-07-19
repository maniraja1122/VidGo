import 'package:flutter/material.dart';
import 'package:socialframe/Widgets/RoundButton.dart';

import '../../Routes.dart';

class Selector extends StatelessWidget {
  const Selector({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Social Frame",
                style: TextStyle(color: Colors.black, fontSize: 40,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Text(
                "All your social circles in a single frame",
                style: TextStyle(color: Colors.black54,fontSize: 15),
              ),
              SizedBox(
                height: 300,
              ),
              RoundButton(
                text: "Login",
                bacground: Colors.white,
                foreground: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.Login);
                },
              ),
              SizedBox(
                height: 10,
              ),
              RoundButton(
                text: "Sign Up",
                bacground: Colors.blue,
                foreground: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.Signup);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
