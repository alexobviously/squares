import 'package:squares_complex/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<GameManager>(context);
    return BlocBuilder<GameManager, GameManagerState>(
      builder: (context, state) {
        return AppBar(
          title: GestureDetector(
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Squares'),
          ),
          actions: [
            IconButton(
              onPressed: () => cubit.nextTheme(),
              icon: const Icon(MdiIcons.palette),
            ),
            IconButton(
              onPressed: () => cubit.nextHighlightTheme(),
              icon: const Icon(MdiIcons.selectionEllipse),
            ),
            DropdownButton<int>(
              value: state.pieceSetIndex,
              items: const [
                DropdownMenuItem(
                  child: Text('Merida'),
                  value: 0,
                ),
                DropdownMenuItem(
                  child: Text('Letters'),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text('Emojis'),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text('Kaneo (SVG)'),
                  value: 3,
                ),
              ],
              onChanged: (x) => cubit.changePieceSet(x),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
