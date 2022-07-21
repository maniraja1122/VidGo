import 'package:flutter/material.dart';
import 'package:VidGo/Widgets/RoundButton.dart';

import '../../Routes.dart';

class Selector extends StatelessWidget {
  const Selector({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150,),
                Image.asset("assets/images/icon.png",width: 100,height: 100,),
                SizedBox(
                  height: 200,
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
      ),
    );
  }
}
