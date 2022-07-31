import 'package:squares_complex/app_bar.dart';
import 'package:squares_complex/game_page.dart';
import 'package:flutter/material.dart';

class GameFullscreen extends StatelessWidget {
  final GamePage gamePage;
  const GameFullscreen(this.gamePage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: GamePage(
        game: gamePage.game,
        pieceSet: gamePage.pieceSet,
        theme: gamePage.theme,
        markerTheme: gamePage.markerTheme,
      ),
    );
  }
}
