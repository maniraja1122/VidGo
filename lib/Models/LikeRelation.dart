

class LikeRelation{
  String UserKey="";
  int PostKey=0;
  LikeRelation({required this.PostKey,required this.UserKey});
  Map<String,dynamic> toMap(){
    return {
      "UserKey":this.UserKey,
      "PostKey":this.PostKey,
    };
  }
}