import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cell.dart';
import '../models/init_value.dart';

class CellItems extends ChangeNotifier {
  var _row = 0;
  var _column = 0;
  var _minesLoc = [];
  List<List<Cell>> _grid;
  int _numberOfMines = 4;
  int _numberOfFlags = 0;

  bool started = false;
  bool get display => (size >= _numberOfMines);

  int get mines => _numberOfMines;
  int get flags => _numberOfFlags;

  void initializeGrid() {
    _grid = _make2DList;
    started = false;
    _numberOfFlags = 0;
    notifyListeners();
  }

  void _start(int x, int y) {
    var options = [];
    for (var i = 0; i < _row; i++) {
      for (var j = 0; j < _column; j++) {
        if (size > _numberOfMines) {
          if (i == x && j == y) continue;
        }
        options.add([i, j]);
      }
    }

    for (var n = 0; n < _numberOfMines; n++) {
      var index = Random().nextInt(options.length);
      var choice = options.removeAt(index);
      var i = choice[0];
      var j = choice[1];
      _grid[i][j].mine = true;
      _minesLoc.add([i, j]);
    }

    for (var i = 0; i < _row; i++) {
      for (var j = 0; j < _column; j++) {
        countNeighbors(i, j);
      }
    }
  }

  void countNeighbors(int x, int y) {
    var total = 0;
    if (_grid[x][y].mine) {
      _grid[x][y].neighborsCount = -1;
      return;
    }

    for (int xoff = -1; xoff <= 1; xoff++) {
      for (int yoff = -1; yoff <= 1; yoff++) {
        int i = x + xoff;
        int j = y + yoff;

        if (i > -1 && i < _row && j > -1 && j < _column) {
          var neighbor = _grid[i][j];
          if (neighbor.mine) {
            total++;
          }
        }
      }
    }

    _grid[x][y].neighborsCount = total;
  }

  void floodFill(int x, int y) {
    for (int xoff = -1; xoff <= 1; xoff++) {
      for (int yoff = -1; yoff <= 1; yoff++) {
        int i = x + xoff;
        int j = y + yoff;

        if (i > -1 && i < _row && j > -1 && j < _column) {
          var neighbor = _grid[i][j];
          if (!neighbor.mine && !neighbor.revealed) {
            reveal(i, j);
          }
        }
      }
    }
  }

  bool reveal(int x, int y) {
    if (!started) {
      _start(x, y);
      started = true;
    }

    if (_grid[x][y].mine) {
      _grid[x][y].iconColor = Colors.red;
      gameOver();
      return false;
    }

    _grid[x][y].revealed = true;
    notifyListeners();

    if (grid[x][y].neighborsCount == 0) {
      floodFill(x, y);
    }
    return true;
  }

  void gameOver() {
    for (var i = 0; i < _row; i++) {
      for (var j = 0; j < _column; j++) {
        if (!_grid[i][j].revealed) _grid[i][j].revealed = true;
      }
    }
    notifyListeners();
  }

  void setFlag(int x, int y) {
    if (!_grid[x][y].revealed) {
      _grid[x][y].flag = !(_grid[x][y].flag);
      _grid[x][y].flag ? _numberOfFlags++ : _numberOfFlags--;
      notifyListeners();
    }
  }

  bool get showFlag => flags < mines;

  set values(InitValues values) {
    if (values == null) return;
    this._row = values.row;
    this._column = values.column;
    this._numberOfMines = values.noOfMines;
    initializeGrid();
  }

  int get width => _column;

  int get size => _row * _column;

  List<List<Cell>> get grid => [..._grid];

  List<List<Cell>> get _make2DList => List.generate(
      _row, (_rowIndex) => List.generate(_column, (colIndex) => Cell()));
}
