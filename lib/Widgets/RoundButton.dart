
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  dynamic onPressed=()async{};
  Color foreground=Colors.black;
  Color bacground=Colors.white;
  String text="";
  RoundButton({Key? key,required this.text,required this.bacground,required this.foreground,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        width: 200,
        child: Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: foreground)),
        alignment: Alignment.center,
        decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.black,width: 2),color:bacground ),
      ),
    );
  }
}
