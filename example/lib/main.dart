import 'package:example/game_controller.dart';
import 'package:example/game_manager.dart';
import 'package:example/home_view.dart';
import 'package:flutter/material.dart';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squares/squares.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameManager>(
          create: (ctx) => GameManager(),
        ),
      ],
      child: MaterialApp(
        title: 'Squares Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.cyan,
        ),
        home: HomeView(),
      ),
    );
  }
}
