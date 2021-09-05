import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reunion_match/model/player_model.dart';
import 'package:reunion_match/model/team_model.dart';
import 'package:rxdart/subjects.dart';

class TeamBloc {
  final BehaviorSubject<List<Team>> _teamsModel =
      BehaviorSubject<List<Team>>.seeded([]);

  final BehaviorSubject<int> _currentTab = BehaviorSubject<int>.seeded(0);

  Stream<List<Team>> get teamsList => _teamsModel.stream;
  List<Team> get teamsListValue => _teamsModel.value;
  Function(List<Team>) get updateTeamsList => _teamsModel.sink.add;

  Stream<int> get currentTab => _currentTab.stream;
  int get currentTabValue => _currentTab.value;
  Function(int) get updateCurrentTab => _currentTab.sink.add;

  void dispose() {
    _teamsModel.close();
    _currentTab.close();
  }

  fetchTeamsDummy() {
    Player playerA = Player("Player A", 1, 95);
    Player playerB = Player("Player B", 0, 23);
    Player playerC = Player("Player C", 0, 45);
    List<Team> teams = [];
    List<Player> players = [];
    for (var i = 0; i < 50; i++) {
      players.add(playerB);
      players.add(playerC);
    }
    Team teamA = Team("Conquerors", playerA, "logo", players);
    Team teamB = Team("Vikings", playerA, "logo", players);
    teams.add(teamA);
    teams.add(teamB);
    //teams.add(teamC);

    updateTeamsList(teams);
  }

  fetchTeams() async {
    List<Team> teams = [];
    fetchTeamsDummy();
    teams.add(await _fetchTeam("Team A"));
    teams.add(await _fetchTeam("Team B"));
    updateTeamsList([]);
    updateTeamsList(teams);
  }

  Future<Team> _fetchTeam(String code) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("Teams").doc(code).get();

    if (documentSnapshot.exists) {
      List<Player> players = [];
      print(documentSnapshot.get('name'));
      print(documentSnapshot.get('logo'));
      List<dynamic> temp = documentSnapshot.get('players');
      List<DocumentReference<Map<String, dynamic>>> list = temp.cast();
      for (var item in list) {
        DocumentSnapshot player = await item.get();
        print(player.get("Name"));
        players.add(Player(player.get("Name"), player.get("Votes"),
            player.get("votesRemaining")));
      }
      Team team = Team(documentSnapshot.get('name'), players[0],
          documentSnapshot.get('logo'), players);
      return team;
    } else {
      Player playerA = Player("Player A", 1, 95);
      Player playerB = Player("Player B", 0, 23);
      Player playerC = Player("Player C", 0, 45);
      List<Player> players = [];
      for (var i = 0; i < 50; i++) {
        players.add(playerB);
        players.add(playerC);
      }
      Team teamA = Team("Conquerors", playerA, "logo", players);

      return teamA;
    }
  }
}
