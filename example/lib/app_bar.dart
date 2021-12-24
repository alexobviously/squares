import 'package:example/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<GameManager>(context);
    return BlocBuilder<GameManager, GameManagerState>(
      builder: (context, state) {
        return AppBar(
          title: Text('Squares'),
          actions: [
            IconButton(
              onPressed: () => cubit.nextTheme(),
              icon: Icon(MdiIcons.palette),
            ),
            DropdownButton<int>(
              value: state.pieceSetIndex,
              items: [
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
              ],
              onChanged: (x) => cubit.changePieceSet(x),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
