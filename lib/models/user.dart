import 'package:firebase_database/firebase_database.dart';

class User {
  String email;
  String userId;
  List<String> messages;

  User(String email, String userId, List<String> messages){
    this.email = email;
    this.userId = userId;
    this.messages = messages;
  }

  String getEmail() => email;

  String getUserId() => userId;

  List<String> getMessages() => messages;

  static final String EMAIL = "email";
  static final String USERID = "userId";
  static final String MESSAGES = "messages";

  Map<String, dynamic> toMap() {
    return {
      EMAIL : email,
      USERID : userId,
      MESSAGES : messages,
    };
  }

  static User fromMap(Map<String, dynamic> data, {String userId}) {

    String userName = data[USERID];
    String email = data[EMAIL];
    List<String> messages = data[MESSAGES];

    return new User(
        email, userId, messages
    );
  }
}