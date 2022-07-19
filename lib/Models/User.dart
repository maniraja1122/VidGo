
class Users {
  Users({required this.key,required this.Name,required this.Email,required this.Password});
  String Name = "NA";
  String Email = "NA";
  String Password = "NA";
  String key = "";
  String Description = "";
  int ReadNotifications = 0;
  String MyPICUrl = "";
  Map<String,dynamic> toMap(){
    return {
      "key":this.key,
      "Name":this.Name,
      "Email":this.Email,
      "Password":this.Password,
      "MyPICUrl":this.MyPICUrl,
      "Description":this.Description,
      "ReadNotifications":this.ReadNotifications
    };
  }
  }

