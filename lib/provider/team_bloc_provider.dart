import 'package:flutter/material.dart';
import 'package:reunion_match/bloc/team_bloc.dart';

class TeamBlocProvider extends InheritedWidget {
  TeamBlocProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  final TeamBloc _teamBloc = TeamBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static TeamBloc getTeamBloc(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TeamBlocProvider>()!._teamBloc;
}
