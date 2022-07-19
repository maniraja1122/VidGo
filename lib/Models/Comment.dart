import '../Repository/AuthHelper.dart';

class Comment {
  int key = DateTime.now().microsecondsSinceEpoch;
  String text="";
  String userkey="";
  int postkey=0;
  Comment({required this.postkey,required this.userkey,required this.text});
  Map<String,dynamic> toMap(){
    return {
      "key":this.key,
      "text":this.text,
      "userkey":this.userkey,
      "postkey":this.postkey,
    };
  }
}