import 'package:flutter/material.dart';

import '../Repository/AuthHelper.dart';

class Notifications{
  int key = DateTime.now().microsecondsSinceEpoch;
  String targetuser="";
  String type="";
  String mytext="";
  String VisitingUnit = "";
  String imgurl="";
  Notifications({required this.targetuser,required this.mytext,required this.type,required this.VisitingUnit,required this.imgurl});
  Map<String,dynamic> toMap(){
    return {
      "key":this.key,
      "targetuser":this.targetuser,
      "type":this.type,
      "mytext":this.mytext,
      "VisitingUnit":this.VisitingUnit,
      "imgurl":this.imgurl
    };
  }
}
//For Types
//        1- if someone follows you
//        2- if someone likes your post
//        3- if someone comments on your post
//          type -post -user