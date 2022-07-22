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
    ThemeData theme = ThemeData(
      primarySwatch: Colors.blueGrey,
      fontFamily: GoogleFonts.cairo().fontFamily,
    );
    theme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(secondary: Colors.cyan),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameManager>(
          create: (ctx) => GameManager(),
        ),
      ],
      child: MaterialApp(
        title: 'Squares Demo',
        theme: theme,
        home: HomeView(),
      ),
    );
  }
}
