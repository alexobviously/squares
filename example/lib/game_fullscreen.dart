import 'package:example/app_bar.dart';
import 'package:example/game_manager.dart';
import 'package:example/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameFullscreen extends StatelessWidget {
  final GamePage gamePage;
  const GameFullscreen(this.gamePage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: GamePage(
        game: gamePage.game,
        pieceSet: gamePage.pieceSet,
        theme: gamePage.theme,
      ),
    );
  }
}
