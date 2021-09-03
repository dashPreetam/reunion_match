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

  fetchTeams() {
    //TODO :  Implement firestore call
  }
}
