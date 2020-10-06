import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reunion_match/customAppBar.dart';
import 'package:reunion_match/customDrawer.dart';

class Votes extends StatefulWidget {
  @override
  _VotesState createState() => _VotesState();
}

class _VotesState extends State<Votes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Votes"),
      drawer: CustomDrawer(),
      body: VotesBody(),
    );
  }
}

class VotesBody extends StatefulWidget {
  @override
  _VotesBodyState createState() => _VotesBodyState();
}

class _VotesBodyState extends State<VotesBody> {
  var user;
  var votesLeft;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('Members')
        .doc(user.uid)
        .get()
        .then((document) {
      setState(() {
        votesLeft = document['votesRemaining'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        votesRemaining(),
        candidates(),
      ],
    );
  }

  votesRemaining() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Members')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Text(
                    "Votes Remaining : " +
                        snapshot.data['votesRemaining'].toString(),
                    style: TextStyle(fontSize: 35)));
          } else
            return CircularProgressIndicator();
        });
  }

  candidates() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Members")
            .orderBy("Votes", descending: true)
            .orderBy("Name", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => candidate(
                    snapshot.data.docs[index],
                    snapshot.data.docs[index]['Name'],
                    snapshot.data.docs[index]['image'],
                    snapshot.data.docs[index]['Votes'],
                    index),
              ),
            );
        });
  }

  candidate(QueryDocumentSnapshot snapshot, String name, String image,
      int votes, int index) {
    name = name.trim();
    name = name.substring(0, name.indexOf(" "));
    if (index == 0)
      snapshot.reference.update({
        'isFirstCaptain': true,
      });
    else if (index == 1)
      snapshot.reference.update({
        'isSecondCaptain': true,
      });
    else
      snapshot.reference.update({
        'isFirstCaptain': false,
        'isSecondCaptain': false,
      });
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: FlatButton(
        onPressed: () {
          dialogView(snapshot);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: 35,
              child: FadeInImage.assetNetwork(
                  placeholder: 'images/robot.png', image: image),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 35),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              color: Colors.grey,
              child: Text(votes.toString(), style: TextStyle(fontSize: 35)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> dialogView(QueryDocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('Members')
        .doc(user.uid)
        .get()
        .then((document) {
      setState(() {
        votesLeft = document['votesRemaining'];
      });
    });

    var alert;

    if (user.uid == snapshot['id'] || votesLeft == 0) {
      alert = AlertDialog(
        title: Text('Vote Confirmation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('CANNOT VOTE!!!'),
              Text('Press No to cancel.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      alert = AlertDialog(
        title: Text('Vote Confirmation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to vote for ${snapshot['Name']}?'),
              Text('Press Yes to confirm.'),
              Text('Press No to cancel.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('Members')
                  .doc(user.uid)
                  .get()
                  .then((document) {
                print("\n\n\n\n\n Swastik");
                print(document['votesRemaining']);
                document.reference.update({
                  'votesRemaining': document['votesRemaining'] - 1,
                  'votedFor': document['votedFor'] + " " + snapshot['Name'],
                });
                setState(() {
                  votesLeft = votesLeft - 1;
                });
              });
              snapshot.reference.update({
                'Votes': snapshot['Votes'] + 1,
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
