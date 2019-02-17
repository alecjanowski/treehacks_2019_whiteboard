import 'package:flutter/material.dart';
import 'package:treehacks_2019_whiteboard/services/authentication.dart';
import 'package:treehacks_2019_whiteboard/pages/root_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';
import 'dart:io';

class TextWall extends StatefulWidget {
  final String userid;
  final double latitude; final double longitude;

  TextWall({Key key, @required this.userid, @required this.latitude, @required this.longitude}) : super(key: key);

  @override
  State createState() => new TextWallState(userid: userid, latitude: latitude, longitude: longitude);
}

class TextWallState extends State<TextWall> {
  String userid;
  double latitude; double longitude;

  TextWallState({Key key, @required this.userid, @required this.latitude, @required this.longitude});

  String location = '1.000, 1.000';// latitude.toStringAsFixed(3) + ", " + longitude.toStringAsFixed(3);
  var listMessage; //dunno what this is

  bool isLoading;

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode(); // DUNNO IF NECESSARY.

  @override
  void initState() {
    super.initState();

    isLoading = false;

    //readLocal(); this seems to
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List messages
              buildListMessage(),
              // Input messages
              // buildInput(),
            ],
          ),
          // Loads
          buildLoading()
        ],
      ),
      // loading
      onWillPop: onBackPress,
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: location == ''
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7e00))))
          : StreamBuilder(
        stream: Firestore.instance.collection('messages').snapshots(), //gets data from firestore
        builder: (context, snapshot) { //builds the message list from snapshot data
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7e00))));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  // Draws each individual message
  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['userId'] == userid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Color(0xfffff5)),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: Color(0xff9835), borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
    else {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Color(0xfffff5)),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: Color(0x410806), borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(left: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
  }

  /*
  // input stuff
  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Color(0xf5f5f5), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Color(0x4545ff)),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
    );
  }
*/
  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['userId'] == userid) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['userId'] != userid) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7e00))),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }
}