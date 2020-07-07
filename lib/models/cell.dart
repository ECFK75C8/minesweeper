import 'package:flutter/material.dart';
// import 'dart:convert';

class Cell {
  bool mine = false;
  bool flag = false;
  bool revealed = false;
  int neighborsCount = 0;
  Color iconColor = Colors.black;
  IconData flagIcon = Icons.flag;

  // Cell();
  // Cell.init({
  //   this.mine,
  //   this.flag,
  //   this.revealed,
  //   this.neighborsCount,
  //   this.iconColor,
  // });

  // factory Cell.fromMap(Map<String, dynamic> mapData) => Cell.init(
  //     mine: mapData['mine'],
  //     flag: mapData['flag'],
  //     revealed: mapData['revealed'],
  //     neighborsCount: mapData['neighborsCount'],
  //     iconColor: mapData['iconColor']);

  // static Map<String, dynamic> toMap(Cell cell) => {
  //       'mine': cell.mine,
  //       'flag': cell.flag,
  //       'revealed': cell.revealed,
  //       'neighborsCount': cell.neighborsCount,
  //       'iconColor': cell.iconColor
  //     };

  // static String encodeCells(List<List<Cell>> cells) => json.encode(
  //     cells.map((row) => row.map((e) => Cell.toMap(e)).toList()).toList());

  // static List<List<Cell>> decodeCells(String cells) =>
  //     (json.decode(cells) as List<List<dynamic>>)
  //         .map((row) => row.map<Cell>((e) => Cell.fromMap(e)).toList())
  //         .toList();
}
