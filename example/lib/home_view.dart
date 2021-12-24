import 'dart:math';

import 'package:example/app_bar.dart';
import 'package:example/game_config.dart';
import 'package:example/game_controller.dart';
import 'package:example/game_creator.dart';
import 'package:example/game_fullscreen.dart';
import 'package:example/game_manager.dart';
import 'package:example/game_page.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:squares/squares.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _pageController = PageController(
      viewportFraction: 0.8,
      keepPage: true,
      initialPage: 0,
    )..addListener(_pageChanged);
  }

  void _pageChanged() {
    int newPage = _pageController.page!.round();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _pageController.dispose();
  }

  void _onCreateGame(GameConfig config) => BlocProvider.of<GameManager>(context).createGame(config);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<GameManager>(context);
    return Scaffold(
      appBar: MyAppBar(),
      body: BlocBuilder<GameManager, GameManagerState>(
        builder: (context, state) {
          final games = state.games;
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: games.length + 1,
                      itemBuilder: (context, i) {
                        if (i == games.length) {
                          return Card(
                            child: GameCreator(
                              onCreate: _onCreateGame,
                            ),
                          );
                        } else {
                          final _page = GamePage(
                            game: games[i],
                            theme: state.theme,
                            pieceSet: state.pieceSet,
                          );
                          return Card(
                            child: Stack(
                              children: [
                                _page,
                                Positioned(
                                  top: 4.0,
                                  right: 4.0,
                                  child: IconButton(
                                    icon: Icon(MdiIcons.arrowExpand),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => GameFullscreen(_page),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4.0,
                                  left: 4.0,
                                  child: IconButton(
                                    icon: Icon(MdiIcons.close),
                                    onPressed: () => cubit.removeGame(i),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
