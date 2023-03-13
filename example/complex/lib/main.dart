import 'package:squares_complex/game_manager.dart';
import 'package:squares_complex/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      primarySwatch: Colors.blueGrey,
      // fontFamily: 'Times new roman',
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
        home: const HomeView(),
      ),
    );
  }
}
