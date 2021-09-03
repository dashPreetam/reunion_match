import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Members")
                .orderBy("Votes", descending: true)
                .snapshots(),
            builder: (BuildContext streamBuilderContext,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => candidate(
                        snapshot.data!.docs[index],
                        snapshot.data!.docs[index]['Name'],
                        snapshot.data!.docs[index]['image'],
                        snapshot.data!.docs[index]['Votes'],
                        index),
                  ),
                );
              } else {
                print(snapshot.connectionState);
                print(snapshot.data);
                return Center(
                  child: Text(snapshot.stackTrace.toString()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  candidate(QueryDocumentSnapshot snapshot, String name, String image,
      int votes, int index) {
    name = name.trim();
    name = name.substring(0, name.indexOf(" "));
    if (index == 0)
      snapshot.reference.update({
        'isFirstCaptain': true,
        'isSecondCaptain': false,
      });
    else if (index == 1)
      snapshot.reference.update({
        'isFirstCaptain': false,
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
          //dialogView(snapshot);
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
              "$name",
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
}
