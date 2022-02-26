import 'package:squares_complex/game_manager.dart';
import 'package:squares_complex/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
          fontFamily: GoogleFonts.cairo().fontFamily,
        ),
        home: HomeView(),
      ),
    );
  }
}
