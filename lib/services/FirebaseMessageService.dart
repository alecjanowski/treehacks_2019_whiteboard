
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treehacks_2019_whiteboard/AppServices.dart';
import 'package:treehacks_2019_whiteboard/models/message.dart';
import 'package:treehacks_2019_whiteboard/services/MessageService.dart';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMessageService implements MessageService {

  static final String MESSAGE_COLLECTION_NAME = "messages";

  CollectionReference _messageCollection;
  CollectionReference _inboundMessageCollection;

  FirebaseMessageService() {
    _messageCollection = AppServices.getFB().getFirestore().collection(MESSAGE_COLLECTION_NAME);
    _inboundMessageCollection = AppServices.getFB().getFirestore().collection(MESSAGE_COLLECTION_NAME);
  }

  @override
  Future<bool> postMessage(String content) {
    _messageCollection.add({
    "key": "testing",
    "message": content});
  }



}