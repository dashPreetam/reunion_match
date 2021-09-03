import 'package:reunion_match/model/player_model.dart';

class Team {
  final String name;
  final Player captain;
  final String logo;
  final List<Player> players;

  Team(this.name, this.captain, this.logo, this.players);
}
