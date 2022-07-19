
class FollowRelation{
  String FollowerID="";
  String FollowedID="";
  FollowRelation({required this.FollowedID,required this.FollowerID});
  Map<String,dynamic> toMap(){
    return {
      "FollowerID":this.FollowerID,
      "FollowedID":this.FollowedID,
    };
  }
}