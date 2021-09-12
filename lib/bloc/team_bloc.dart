import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reunion_match/model/batting_stats_model.dart';
import 'package:reunion_match/model/bowling_stats_model.dart';
import 'package:reunion_match/model/player_model.dart';
import 'package:reunion_match/model/team_model.dart';
import 'package:rxdart/subjects.dart';

class TeamBloc {
  final BehaviorSubject<List<Team>> _teams =
      BehaviorSubject<List<Team>>.seeded([]);

  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>();

  final BehaviorSubject<int> _currentTab = BehaviorSubject<int>.seeded(0);

  Stream<List<Team>> get teamsList => _teams.stream;
  List<Team> get teamsListValue => _teams.value;
  Function(List<Team>) get updateTeamsList => _teams.sink.add;

  Stream<bool> get isLoading => _isLoading.stream;
  bool get isLoadingValue => _isLoading.value;
  Function(bool) get updateIsLoading => _isLoading.sink.add;

  Stream<int> get currentTab => _currentTab.stream;
  int get currentTabValue => _currentTab.value;
  Function(int) get updateCurrentTab => _currentTab.sink.add;

  void dispose() {
    _teams.close();
    _isLoading.close();
    _currentTab.close();
  }

  fetchTeams() async {
    List<Team> teams = [];
    updateIsLoading(true);
    Team? teamA = await _fetchTeam("Team A");
    Team? teamB = await _fetchTeam("Team B");
    teams.add(teamA!);
    teams.add(teamB!);
    if (teams.isNotEmpty) {
      updateIsLoading(false);
      updateTeamsList(teams);
    } else
      updateIsLoading(true);
  }

  Future<Team?> _fetchTeam(String code) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("Teams").doc(code).get();
    BattingStats battingStat = new BattingStats(1, 1, 1, 1.0, 1.0, 1, 1, 1);
    BowlingStats bowlingStat = new BowlingStats(1, 1, 1, 1.0, 1.0, 1, 1, 1);

    if (documentSnapshot.exists) {
      List<Player> players = [];

      DocumentReference<Map<String, dynamic>> captainReference =
          await documentSnapshot.get("Captain");
      DocumentSnapshot captainDocument = await captainReference.get();
      Player captain = new Player(
          captainDocument.get("Name"),
          captainDocument.get("Votes"),
          captainDocument.get("votesRemaining"),
          battingStat,
          bowlingStat);

      List<dynamic> temp = documentSnapshot.get('Players');
      List<DocumentReference<Map<String, dynamic>>> list = temp.cast();
      for (var item in list) {
        DocumentSnapshot player = await item.get();
        players.add(Player(player.get("Name"), player.get("Votes"),
            player.get("votesRemaining"), battingStat, bowlingStat));
      }

      Team team = Team(documentSnapshot.get('Name'), captain,
          documentSnapshot.get('Logo'), players);
      return team;
    } else
      return null;
  }
}
