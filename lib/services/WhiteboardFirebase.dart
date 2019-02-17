import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WhiteboardFirebase {

  static final String FIREBASE_APP_NAME = "Whiteboard";

  static String getFirebaseAppName() {
    return FIREBASE_APP_NAME;
  }

  static FirebaseOptions getFirebaseOptions() {
    final FirebaseOptions options = const FirebaseOptions(
      //might suck
        googleAppID: "1:915080686531:ios:16067db765c59670",
        apiKey: "AIzaSyB2uCRNVhaBGJ0PfZrNHJGYoqeYdZK4KiM",
        projectID: "treehacks-project");


    return options;
  }

  static Future<WhiteboardFirebase> createInstance() async {
    final String name = WhiteboardFirebase.getFirebaseAppName();
    final FirebaseOptions options = WhiteboardFirebase.getFirebaseOptions();
    FirebaseApp firebaseApp = await FirebaseApp.configure(
      name: name,
      options: options,
    );

    return new WhiteboardFirebase(firebaseApp);
  }


  //////////
  //Instance
  FirebaseApp _firebaseApp;

  Firestore _firestore;
  FirebaseAuth _firebaseAuth;

  WhiteboardFirebase(FirebaseApp firebaseApp) {
    print("Assigning firebaseApp instance to given firebaseApp");
    _firebaseApp = firebaseApp;


    print("Creating firestore");
    _firestore = new Firestore(app: _firebaseApp);


    print("Creating FirebaseAuth");
    _firebaseAuth = FirebaseAuth.instance;
  }

  FirebaseApp getFirebaseApp() => _firebaseApp;

  Firestore getFirestore() => _firestore;

  FirebaseAuth getFirebaseAuth() => _firebaseAuth;
}