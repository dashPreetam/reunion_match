import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reunion_match/customAppBar.dart';
import 'package:reunion_match/customDrawer.dart';
import 'package:reunion_match/info.dart';
import 'package:reunion_match/teamBody.dart';
import 'package:reunion_match/teamBuild.dart';
import 'package:reunion_match/voteBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        //createData();
        //deleteData();
        return MaterialApp(
          theme: ThemeData.light(),
          debugShowCheckedModeBanner: false,
          home: SignIn(),
          routes: {
            '/teams': (context) => Teams(),
            '/votes': (context) => Votes(),
            '/info': (context) => Scaffold(
                  appBar: CustomAppBar(title: "Info"),
                  drawer: CustomDrawer(),
                  body: Info(),
                ),
            '/build': (context) => TeamBuild(),
          },
        );
      }
      return MaterialApp(
        home: Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        )),
      );
    },
  ));
}

createData() {
  for (int i = 1; i <= 5; i++) {
    FirebaseFirestore.instance
        .collection('Members')
        .doc(DateTime.now().toString())
        .set({
      'Name': "Test " + i.toString(),
      'image': "https://miro.medium.com/max/560/1*MccriYX-ciBniUzRKAUsAw.png",
      'id': DateTime.now().toString(),
      'Votes': 0,
      'votedFor': "",
      'votesRemaining': 2,
      'isFirstCaptain': false,
      'isSecondCaptain': false,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}

deleteData() {
  FirebaseFirestore.instance.collection('Members').get().then((value) {
    for (var val in value.docs) {
      val.reference.update({
        "team": "",
        "votedFor": "",
      });
    }
  });
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "REUNION"),
      body: Center(
        child: FlatButton(
            onPressed: handleSignIn,
            child: Text(
              'SIGN IN WITH GOOGLE',
              style: TextStyle(fontSize: 16.0),
            ),
            color: Color(0xffdd4b39),
            highlightColor: Color(0xffff7f7f),
            splashColor: Colors.transparent,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
      ),
    );
  }

  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed("/votes");
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('Members')
          .where('id', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        print("\n\n\n\n Swastik");
        print("here");
        FirebaseFirestore.instance
            .collection('Members')
            .doc(firebaseUser.uid)
            .set({
          'Name': firebaseUser.displayName,
          'image': firebaseUser.photoURL,
          'id': firebaseUser.uid,
          'Votes': 0,
          'team': "",
          'votedFor': "",
          'votesRemaining': 2,
          'isFirstCaptain': false,
          'isSecondCaptain': false,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('Name', currentUser.displayName);
        await prefs.setString('image', currentUser.photoURL);
        await prefs.setInt('Votes', 0);
      } else {
        print("\n\n\n\n Swastik");
        print("here2");
        await prefs.setString('id', documents[0].data()['id']);
        await prefs.setString('Name', documents[0].data()['Name']);
        await prefs.setString('image', documents[0].data()['image']);
        await prefs.setInt('Votes', documents[0].data()['Votes']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushReplacementNamed("/votes");
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
