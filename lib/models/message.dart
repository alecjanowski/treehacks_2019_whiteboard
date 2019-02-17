import 'package:firebase_database/firebase_database.dart';

class Message {
  String content;
  String userId;

  Message(String content, String userId){
    this.content = content;
    this.userId = userId;
  }

  String getContent(){
    return this.content;
  }

  String getUserId() {
    return this.userId;
  }

  toJson() {
    return {
      "userId": userId,
      "content": content,
    };
  }
}