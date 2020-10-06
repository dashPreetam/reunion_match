import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reunion_match/customAppBar.dart';
import 'package:reunion_match/customDrawer.dart';

class TeamBuild extends StatefulWidget {
  @override
  _TeamBuildState createState() => _TeamBuildState();
}

class _TeamBuildState extends State<TeamBuild> {
  var user;
  bool isCaptain;
  int myTurn;
  bool isMyTurn;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    setIsCaptain();
    super.initState();
  }

  Future<void> setIsCaptain() async {
    await FirebaseFirestore.instance
        .collection('Members')
        .doc(user.uid)
        .get()
        .then((document) {
      if (document['isFirstCaptain']) {
        setState(() {
          isCaptain = true;
          myTurn = 1;
        });
      } else if (document['isSecondCaptain']) {
        setState(() {
          isCaptain = true;
          myTurn = 2;
        });
      } else
        setState(() {
          isCaptain = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCaptain) {
      FirebaseFirestore.instance
          .collection('Teams')
          .doc('turn')
          .get()
          .then((document) {
        if (document['turn'] == myTurn) {
          setState(() {
            isMyTurn = true;
          });
        } else {
          setState(() {
            isMyTurn = false;
          });
        }
      });
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: "Teams Divide",
      ),
      drawer: CustomDrawer(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 18,
              child: timeLine(),
            ),
          ],
        ),
      ),
      floatingActionButton: isCaptain
          ? FloatingActionButton(
              onPressed: () => addPlayer(context),
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  timeLine() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("TimeLine").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.docs[index]),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  buildItem(int index, QueryDocumentSnapshot doc) {
    if (doc['by'] == "Admin") {
      return showBanner(doc['msg'].toString());
    } else if (doc['by'] == "firstCaptain") {
      return showTimeLine("firstCaptain", CrossAxisAlignment.start,
          doc['msg'].toString(), doc['captain'].toString());
    } else {
      return showTimeLine("secondCaptain", CrossAxisAlignment.end,
          doc['msg'].toString(), doc['captain'].toString());
    }
  }

  showBanner(String string) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.black38),
          child: Text(
            string,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  showTimeLine(
      String name, CrossAxisAlignment align, String string, String captain) {
    return Container(
      padding: name == "firstCaptain"
          ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 1.8)
          : EdgeInsets.only(right: MediaQuery.of(context).size.width / 1.8),
      child: Card(
        borderOnForeground: true,
        child: Column(
          crossAxisAlignment: align,
          children: <Widget>[
            Center(
                child: Text(
              " " + captain,
              style: TextStyle(fontSize: 20),
            )),
            Text(""),
            Center(
                child: Text(
              " " + string,
              style: TextStyle(fontSize: 20),
            ))
          ],
        ),
      ),
    );
  }

  addPlayer(BuildContext context) {
    var alert = AlertDialog();

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
