import 'package:socialframe/Repository/AuthHelper.dart';

class Post {
  String title = "";
  String author = "";
  String imagelink = "";
  int key = 0;
  Post({required this.key,required this.title,required this.author,required this.imagelink});
  Map<String,dynamic> toMap(){
    return {
      "key":this.key,
      "title":this.title,
      "author":this.author,
      "imagelink":this.imagelink,
    };
  }
}
