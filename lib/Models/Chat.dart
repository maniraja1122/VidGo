class Chat{
  var key="";
  var user1="";
  var user2="";
  var lastsend=0;
  Chat({required this.key,required this.lastsend,required this.user2,required this.user1});
  Map<String,dynamic> toMap(){
    return {
      "key":this.key,
      "user1":this.user1,
      "user2":this.user2,
      "lastsend":this.lastsend,
    };
  }
}