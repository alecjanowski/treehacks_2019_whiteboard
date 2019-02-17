import 'package:firebase_database/firebase_database.dart';

class Message {
  String id;
  String content;
  String userId;

  Message(String content, String userId, String id){
    this.id = id;
    this.content = content;
    this.userId = userId;
  }

  String getContent(){
    return this.content;
  }

  String getUserId() {
    return this.userId;
  }

  String getId() {
    return this.id;
  }

  static final String ID = "id";
  static final String CONTENT = "content";
  static final String USERID = "userId";

  Map<String, dynamic> toMap() {
    return {
      ID : id,
      CONTENT : content,
      USERID : userId,
    };
  }

  static Message fromMap(Map<String, dynamic> data, {String messageId}) {

    String userId = data[USERID];
    String content = data[CONTENT];
    String id = data[ID];

    return new Message(
        content, userId, id
    );
  }
}