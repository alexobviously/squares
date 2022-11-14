import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squares_complex/app_bar.dart';
import 'package:squares_complex/game_manager.dart';
import 'package:squares_complex/game_page.dart';
import 'package:flutter/material.dart';

class GameFullscreen extends StatelessWidget {
  final GamePage gamePage;
  const GameFullscreen(this.gamePage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: BlocBuilder<GameManager, GameManagerState>(
        builder: (context, state) {
          return GamePage(
            game: gamePage.game,
            pieceSet: state.pieceSet,
            theme: state.theme,
            markerTheme: state.markerTheme,
          );
        },
      ),
    );
  }
}
