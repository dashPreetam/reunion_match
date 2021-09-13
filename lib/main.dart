import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reunion_match/screen/home.dart';
import 'package:reunion_match/util/Constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (BuildContext futureBuilderContext,
        AsyncSnapshot<FirebaseApp> snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return MaterialApp(
          theme: ThemeData.dark().copyWith(
            //primaryColor: Constants.primaryColor,
          ),
          home: Container(
            decoration: BoxDecoration(gradient: Constants.gradient),
            child: HomeScreen(),
          ),
        );
      } else {
        return MaterialApp(
          theme: ThemeData.dark().copyWith(
              primaryColor: Constants.primaryColor,
              accentColor: Constants.secondaryColor),
          home: Scaffold(
            body: Container(
              child: CircularProgressIndicator(
                color: Constants.golden,
              ),
            ),
          ),
        );
      }
    },
  ));
}
