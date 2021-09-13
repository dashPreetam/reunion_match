import 'package:flutter/material.dart';
import 'package:reunion_match/bloc/team_bloc.dart';
import 'package:reunion_match/model/batting_stats_model.dart';
import 'package:reunion_match/model/bowling_stats_model.dart';
import 'package:reunion_match/model/player_model.dart';
import 'package:reunion_match/model/team_model.dart';
import 'package:reunion_match/provider/team_bloc_provider.dart';
import 'package:reunion_match/screen/player_screen.dart';
import 'package:reunion_match/widgets/custom_shimmer/custom_shimmer_listlite.dart';
import 'package:reunion_match/widgets/custom_shimmer/custom_shimmer_title.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TeamBlocProvider(child: TeamBody());
  }
}

class TeamBody extends StatelessWidget {
  const TeamBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TeamBloc teamBloc = TeamBlocProvider.getTeamBloc(context);
    teamBloc.fetchTeams();

    return StreamBuilder(
      stream: teamBloc.isLoading,
      builder: (BuildContext streamContext, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && !snapshot.data!) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Teams"),
              actions: [
                IconButton(
                  onPressed: () {
                    teamBloc.refresh();
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
            body: _body(context, teamBloc),
            bottomNavigationBar: StreamBuilder<Object>(
                stream: teamBloc.currentTab,
                builder: (context, snapshot) {
                  return BottomNavigationBar(
                      currentIndex: teamBloc.currentTabValue,
                      onTap: (index) {
                        teamBloc.updateCurrentTab(index);
                      },
                      items: [
                        BottomNavigationBarItem(
                          icon: Container(),
                          label: teamBloc.teamsListValue[0].name,
                        ),
                        BottomNavigationBarItem(
                          icon: Container(),
                          label: teamBloc.teamsListValue[1].name,
                        )
                      ]);
                }),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("Loading Teams"),
            ),
            body: _shimmer(context),
          );
        }
      },
    );
  }

  _body(BuildContext context, TeamBloc teamBloc) {
    return StreamBuilder(
        stream: teamBloc.currentTab,
        builder: (cont, snap) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _teamName(
                    context, teamBloc.teamsListValue[teamBloc.currentTabValue]),
                _teamCaptain(
                    context, teamBloc.teamsListValue[teamBloc.currentTabValue]),
                _teamPlayers(
                    context, teamBloc.teamsListValue[teamBloc.currentTabValue]),
              ],
            ),
          );
        });
  }

  _shimmer(BuildContext context) {
    BattingStats battingStat = new BattingStats(1, 1, 1, 1.0, 1.0, 1, 1, 1);
    BowlingStats bowlingStat = new BowlingStats(1, 1, 1, 1.0, 1.0, 1, 1, 1);
    Player dummy = new Player("Dummy Player", 1, 10, battingStat, bowlingStat);
    return Column(
      children: [
        CustomShimmerTitle(),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlayerScreen(player: dummy)));
            },
            child: CustomShimmerListtile(type: "Captain")),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayerScreen(player: dummy)));
                },
                child: CustomShimmerListtile(
                  type: "Player",
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _teamName(BuildContext context, Team team) {
    return Center(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            team.name,
            style: TextStyle(fontSize: 25),
          )),
    );
  }

  _teamCaptain(BuildContext context, Team team) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerScreen(player: team.captain)));
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          child: Text("${team.captain.jersey}"),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            //color: Colors.white,
          ),
          width: double.infinity,
          height: 25,
          child: Center(
              child: Text(
            "${team.captain.name}",
            style: TextStyle(fontSize: 25),
          )),
        ),
      ),
    );
  }

  _teamPlayers(BuildContext context, Team team) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: team.players.length,
      itemBuilder: (cont, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PlayerScreen(player: team.players[index])));
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 12,
              child: Text("${team.players[index].jersey}"),
            ),
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                //color: Colors.white,
              ),
              width: double.infinity,
              height: 20,
              child: Center(
                child: Text(
                  "${team.players[index].name}",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
