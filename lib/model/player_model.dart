import 'package:reunion_match/model/batting_stats_model.dart';
import 'package:reunion_match/model/bowling_stats_model.dart';

class Player {
  final String name;
  final int jersey;
  final int votes;
  final BattingStats battingStats;
  final BowlingStats bowlingStats;

  Player(
      this.name, this.votes, this.jersey, this.battingStats, this.bowlingStats);
}
