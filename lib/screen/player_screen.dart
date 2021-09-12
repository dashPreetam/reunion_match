import 'package:flutter/material.dart';
import 'package:reunion_match/model/player_model.dart';

class PlayerScreen extends StatelessWidget {
  final Player player;
  const PlayerScreen({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _image(context),
          _info(),
          _batting(),
          _bowling(),
        ],
      ),
    );
  }

  _image(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Placeholder(
        color: Colors.greenAccent,
      ),
    );
  }

  _info() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text("Info"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et accumsan risus. Nullam pretium, lorem id vestibulum interdum, felis orci rutrum metus, vitae tincidunt nisi dolor vitae mauris. Cras porttitor blandit mauris eget sagittis. Curabitur pharetra turpis sed imperdiet lobortis. Aliquam sit amet quam ac nisl dignissim tristique a in ex. Sed ultrices lacinia enim, ut commodo felis porttitor nec. Phasellus iaculis ipsum quam, vel varius enim semper in. Suspendisse potenti. Duis quis facilisis ipsum, quis rutrum nisi."),
          ),
        ],
      ),
    );
  }

  _batting() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text("Batting"),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              children: [
                _stat(statname: "Matches", stat: "${player.battingStats.matches}"),
                _stat(statname: "Runs", stat: "${player.battingStats.runs}"),
                _stat(statname: "Balls", stat: "${player.battingStats.balls}"),
                _stat(statname: "Strike Rate", stat: "${player.battingStats.strikeRate}"),
                _stat(statname: "Average", stat: "${player.battingStats.average}"),
                _stat(statname: "50s", stat: "${player.battingStats.fifties}"),
                _stat(statname: "100s", stat: "${player.battingStats.hundreds}"),
                _stat(statname: "Ranking", stat: "${player.battingStats.ranking}"),
              ],
            ),
          )
        ],
      ),
    );
  }

  _bowling() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text("Bowling"),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              children: [
                _stat(statname: "Matches", stat: "${player.bowlingStats.matches}"),
                _stat(statname: "Balls", stat: "${player.bowlingStats.balls}"),
                _stat(statname: "Wickets", stat: "${player.bowlingStats.wickets}"),
                _stat(statname: "Strike Rate", stat: "${player.bowlingStats.strikeRate}"),
                _stat(statname: "Economy", stat: "${player.bowlingStats.economy}"),
                _stat(statname: "5WI", stat: "${player.bowlingStats.fiveHaul}"),
                _stat(statname: "10WI", stat: "${player.bowlingStats.tenHaul}"),
                _stat(statname: "Ranking", stat: "${player.bowlingStats.ranking}"),
              ],
            ),
          )
        ],
      ),
    );
  }

  _stat({required String statname, required String stat}) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(statname),
            ),
            Center(
              child: Text(stat),
            ),
          ],
        ),
      ),
    );
  }
}
