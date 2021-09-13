import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:reunion_match/screen/teams_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Colors.yellow[200]!, Colors.red],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return DefaultTextStyle(
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          foreground: Paint()..shader = linearGradient),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Expanded(child: Container(), flex: 1,),
            Expanded(
              flex: 2,
              child: _nameRow(context),
            ),
            Expanded(flex: 2, child: _infoRow(context)),
            Expanded(flex: 3, child: _navAndLogoRow(context)),
            //Expanded(child: Container(), flex: 1,),
          ],
        ),
      ),
    );
  }

  _nameRow(BuildContext context) {
    return Center(child: Text("B.S.H.S. Classico"));
  }

  _infoRow(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        //color: Colors.white,
      ),
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Details").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData)
              return Marquee(
                text: snapshot.data!.docs[1].get("Message") + "\n",
                style: TextStyle(fontWeight: FontWeight.bold),
                scrollAxis: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 00.0,
                velocity: 10.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              );
            else
              return Marquee(
                text:
                    "\n 2 teams. One epic battle, where players give it all. Not just to win the game, but to strengthen the bond of brotherhood as well.\n",
                style: TextStyle(fontWeight: FontWeight.bold),
                scrollAxis: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 00.0,
                velocity: 10.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              );
          }),
    );
  }

  _navAndLogoRow(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: _nav(context)),
          ),
          Expanded(
            flex: 2,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: _logo(context)),
          ),
        ],
      ),
    );
  }

  _nav(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          OutlinedButton(
            child: Text("Teams"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TeamScreen()));
            },
          ),
          OutlinedButton(
            child: Text("Rankings"),
            onPressed: () {
              final snackBar = SnackBar(
                content: Text('Comming Soon....'),
                duration: Duration(milliseconds: 500),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          OutlinedButton(
            child: Text("Gallery"),
            onPressed: () {
              final snackBar = SnackBar(
                content: Text('Coming Soon....'),
                duration: Duration(milliseconds: 500),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
    );
  }

  _logo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: FittedBox(fit: BoxFit.fill, child: FlutterLogo()),
    );
  }
}
