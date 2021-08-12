import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:squares/squares.dart';

class BoardState extends Equatable {
  final List<String> board;
  final int player;
  late final int orientation;
  final int? lastFrom;
  final int? lastTo;
  final int? checkSquare;

  BoardState({
    required this.board,
    this.player = WHITE,
    orientation,
    this.lastFrom,
    this.lastTo,
    this.checkSquare,
  }) {
    this.orientation = orientation ?? player;
  }
  factory BoardState.empty() => BoardState(board: []);

  BoardState copyWith({
    List<String>? board,
    int? player,
    int? orientation,
    int? lastFrom,
    int? lastTo,
    int? checkSquare,
  }) {
    return BoardState(
      board: board ?? this.board,
      player: player ?? this.player,
      orientation: orientation ?? this.orientation,
      lastFrom: lastFrom ?? this.lastFrom,
      lastTo: lastTo ?? this.lastTo,
      checkSquare: checkSquare ?? this.checkSquare,
    );
  }

  List<Object> get props => [board, player];
}
