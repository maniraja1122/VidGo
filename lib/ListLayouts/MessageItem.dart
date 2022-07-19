import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialframe/Repository/DBHelper.dart';

class MessageItem extends StatelessWidget {
  QueryDocumentSnapshot snap;
  MessageItem({required this.snap,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: (snap.get("sender") != DBHelper.auth.currentUser!.uid?Alignment.topLeft:Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (snap.get("sender") != DBHelper.auth.currentUser!.uid?Colors.grey.shade200:Colors.blue[200]),
          ),
          padding: EdgeInsets.all(16),
          child: Text(snap.get("message"), style: TextStyle(fontSize: 15),),
        ),
      ),
    );;
  }
}
