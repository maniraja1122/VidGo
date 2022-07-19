
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialframe/Models/Chat.dart';
import 'package:socialframe/Models/FollowRelation.dart';
import 'package:socialframe/Models/LikeRelation.dart';
import 'package:socialframe/Models/MessageModel.dart';
import 'package:socialframe/Models/Notifications.dart';
import 'package:socialframe/Models/Post.dart';

class DBHelper {
  static var db = FirebaseFirestore.instance;
  static var auth = FirebaseAuth.instance;
  static var storage = FirebaseStorage.instance;
  static Future<void> FollowUser(
      {required String follower, required String followed}) async {
    db.runTransaction((transaction) async {
      var data = await db
          .collection("FollowRelation")
          .where("FollowerID", isEqualTo: follower)
          .where("FollowedID", isEqualTo: followed)
          .get();
      if (data.docs.length > 0) {
        var securesnap = await transaction.get(data.docs[0].reference);
        await transaction.delete(securesnap.reference);
      } else {
        await db.collection("FollowRelation").add(
            FollowRelation(FollowedID: followed, FollowerID: follower).toMap());
        var allusers=await db.collection("Users").where("key",isEqualTo: follower).get();
        var myuser=allusers.docs[0];
        await db.collection("Notifications").add(Notifications(
                targetuser: followed,
                mytext: myuser.get("Name")+" followed you",
                type: "1",
                VisitingUnit: follower,
                imgurl: myuser.get("MyPICUrl"))
            .toMap());
      }
    });
  }

  static SendMessage(
      {required String user1,
      required String user2,
      required String message}) async {
    var data = await db
        .collection("Chat")
        .where("user1", isEqualTo: user1)
        .where("user2", isEqualTo: user2)
        .get();
    var check1 = data.docs.length;
    if (check1 == 0) {
      await db.collection("Chat").add(Chat(
              key: user1 + user2,
              lastsend: DateTime.now().microsecondsSinceEpoch,
              user2: user2,
              user1: user1)
          .toMap());
      await db.collection("MessageModel").add(
          MessageModel(chatkey: user1 + user2, sender: user1, message: message)
              .toMap());
      await db.collection("Chat").add(Chat(
              key: user2 + user1,
              lastsend: DateTime.now().microsecondsSinceEpoch,
              user2: user1,
              user1: user2)
          .toMap());
      await db.collection("MessageModel").add(
          MessageModel(chatkey: user2 + user1, sender: user1, message: message)
              .toMap());
    } else {
      await db.collection("MessageModel").add(
          MessageModel(chatkey: user1 + user2, sender: user1, message: message)
              .toMap());
      await db.collection("MessageModel").add(
          MessageModel(chatkey: user2 + user1, sender: user1, message: message)
              .toMap());
      var snap = await db
          .collection("Chat")
          .where("user1", isEqualTo: user1)
          .where("user2", isEqualTo: user2)
          .get();
      var snap1 = await db
          .collection("Chat")
          .where("user2", isEqualTo: user1)
          .where("user1", isEqualTo: user2)
          .get();
      await snap.docs[0].reference
          .update({"lastsend": DateTime.now().microsecondsSinceEpoch});
      await snap1.docs[0].reference
          .update({"lastsend": DateTime.now().microsecondsSinceEpoch});
    }
  }

  static Future<void> CreatePost({String title = "", io.File? image}) async {
    var newkey = DateTime.now().microsecondsSinceEpoch;
    await storage.ref().child("Posts").child(newkey.toString()).putFile(image!);
    var newlink = await storage
        .ref()
        .child("Posts")
        .child(newkey.toString())
        .getDownloadURL();
    var newpost = Post(
        key: newkey,
        title: title,
        author: auth.currentUser!.uid,
        imagelink: newlink);
    await db.collection("Post").add(newpost.toMap());
  }

  static Future<void> LikePost(int postid) async {
    var arr = await db
        .collection("LikeRelation")
        .where("UserKey", isEqualTo: auth.currentUser!.uid)
        .where("PostKey", isEqualTo: postid)
        .get();
    if (arr.docs.length > 0) {
      await arr.docs[0].reference.delete();
    } else {
      await db.collection("LikeRelation").add(
          LikeRelation(PostKey: postid, UserKey: auth.currentUser!.uid)
              .toMap());
      var postdetails =
          await db.collection("Post").where("key", isEqualTo: postid).get();
      var post = postdetails.docs[0];
      await db.collection("Notifications").add(Notifications(
              targetuser: post.get("author"),
              mytext: "Someone liked your post",
              type: "2",
              VisitingUnit: postid.toString(),
              imgurl: post.get("imagelink"))
          .toMap());
    }
  }
  static Future<void> UpdateReadNotifications(int val) async {
    var users=await db.collection("Users").where("key",isEqualTo: auth.currentUser!.uid).get();
    var myuser=users.docs[0];
    await myuser.reference.update({
      "ReadNotifications":val
    });
  }
}
