import 'package:flutter/material.dart';
import 'package:reunion_match/bloc/team_bloc.dart';
import 'package:reunion_match/model/player_model.dart';
import 'package:reunion_match/model/team_model.dart';
import 'package:reunion_match/provider/team_bloc_provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text("Teams")),
      body: StreamBuilder(
        stream: teamBloc.teamsList,
        builder: (cont, snap) {
          return _body(teamBloc);
        },
      ),
      bottomNavigationBar: _buttomNavigationBar(teamBloc),
    );
  }

  _buttomNavigationBar(TeamBloc teamBloc) {
    List<Team> teams = teamBloc.teamsListValue;
    List<BottomNavigationBarItem> items = [];

    for (var team in teams) {
      // items.add(BottomNavigationBarItem(
      //     icon: Image.network(team.logo), label: team.name));
      items.add(BottomNavigationBarItem(
          icon: Image.network(
              "https://dieselpunkcore.com/wp-content/uploads/2014/06/logo-placeholder.png"),
          label: team.name));
    }

    return StreamBuilder(
      stream: teamBloc.currentTab,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return BottomNavigationBar(
            items: items,
            currentIndex: snapshot.data,
            onTap: (index) => teamBloc.updateCurrentTab(index),
            selectedItemColor: Theme.of(context).primaryColor,
          );
        } else
          return Text("Loading");
      },
    );
  }

  _body(TeamBloc teamBloc) {
    return StreamBuilder(
      stream: teamBloc.currentTab,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _teamDetails(teamBloc.teamsListValue[snapshot.data]);
        } else
          return Text("Loading");
      },
    );
  }

  _teamDetails(Team team) {
    return Column(
      children: [
        _teamName(team.name),
        _teamCaptain(team.captain),
        _teamPlayers(team.players)
      ],
    );
  }

  _teamName(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 25),
        )
      ],
    );
  }

  _teamCaptain(Player captain) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Center(
          child: Text(
        captain.name,
        style: TextStyle(fontSize: 20),
      )),
      trailing: Text(captain.jersey.toString()),
    );
  }

  _teamPlayers(List<Player> players) {
    return Expanded(
      child: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.person),
                Text(players[index].name),
                Text(players[index].jersey.toString())
              ],
            ),
          );
        },
      ),
    );
  }
}
