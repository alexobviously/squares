import 'package:flutter/material.dart';
import 'package:squares/square.dart';

class Board extends StatelessWidget {
  final int ranks;
  final int files;
  final Color? light;
  final Color? dark;

  Board({
    this.ranks = 8,
    this.files = 8,
    this.light,
    this.dark,
  });

  @override
  Widget build(BuildContext context) {
    Color _light = light ?? Theme.of(context).primaryColorLight;
    Color _dark = dark ?? Theme.of(context).primaryColorDark;
    return AspectRatio(
        aspectRatio: files / ranks,
        child: Container(
            child: Column(
          children: List.generate(
              ranks,
              (rank) => Expanded(
                      child: Row(
                    children: List.generate(
                        files,
                        (file) => Square(
                              id: rank * files + file,
                              colour: ((rank + file) % 2 == 0) ? _light : _dark,
                            )),
                  ))),
        )));
  }
}
