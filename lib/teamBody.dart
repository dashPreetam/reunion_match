import 'package:flutter/material.dart';
import 'package:reunion_match/customAppBar.dart';
import 'package:reunion_match/customDrawer.dart';

class Teams extends StatefulWidget {
  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Teams"),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              TeamBody(teamName: "Team A"),
              Container(
                height: 100,
                child:
                    Center(child: Text("VS", style: TextStyle(fontSize: 45))),
              ),
              TeamBody(teamName: "Team B")
            ],
          ),
        ),
      ),
    );
  }
}

class TeamBody extends StatefulWidget {
  final String teamName;
  TeamBody({Key key, @required this.teamName}) : super(key: key);
  @override
  _TeamBodyState createState() => _TeamBodyState();
}

class _TeamBodyState extends State<TeamBody> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.teamName, style: TextStyle(fontSize: 45)),
      children: [
        Column(children: [
          teamDetails(),
          teamMembers(),
        ])
      ],
    );
  }

  teamDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: FadeInImage.assetNetwork(
                placeholder: 'images/robot.png',
                image:
                    "https://miro.medium.com/max/560/1*MccriYX-ciBniUzRKAUsAw.png")),
        Expanded(
            flex: 5,
            child: Center(
              child: Text(
                "Captain",
                style: TextStyle(fontSize: 35),
              ),
            )),
        Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "XX",
                style: TextStyle(fontSize: 25),
              ),
            )),
      ],
    );
  }

  teamMembers() {
    String name = "Test";
    String image =
        "https://miro.medium.com/max/560/1*MccriYX-ciBniUzRKAUsAw.png";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        player(name, image),
        player(name, image),
        player(name, image),
        player(name, image),
      ],
    );
  }

  player(String name, String image) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: FadeInImage.assetNetwork(
                      placeholder: 'images/robot.png', image: image)),
              Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 35),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
