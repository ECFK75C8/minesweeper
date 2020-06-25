import 'dart:math';
import 'package:flutter/material.dart';
import '../models/cell.dart';

class CellItems extends ChangeNotifier {
  var _width = 0;
  int _numberOfMines = 4;
  List<List<Cell>> _grid;

  bool started = false;
  bool get display => (size >= _numberOfMines);

  void initializeGrid() {
    _grid = _make2DList;
    started = false;

    notifyListeners();
  }

  void start(int x, int y) {
    var options = [];
    for (var i = 0; i < _width; i++) {
      for (var j = 0; j < _width; j++) {
        if (i == x && j == y) continue;
        options.add([i, j]);
      }
    }

    for (var n = 0; n < _numberOfMines; n++) {
      var index = Random().nextInt(options.length);
      var choice = options.removeAt(index);
      var i = choice[0];
      var j = choice[1];
      _grid[i][j].mine = true;
    }

    for (var i = 0; i < _width; i++) {
      for (var j = 0; j < _width; j++) {
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

        if (i > -1 && i < width && j > -1 && j < width) {
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

        if (i > -1 && i < width && j > -1 && j < width) {
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
      start(x, y);
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
    for (var i = 0; i < _width; i++) {
      for (var j = 0; j < _width; j++) {
        if (!_grid[i][j].revealed) _grid[i][j].revealed = true;
      }
    }

    notifyListeners();
  }

  void setFlag(int x, int y) {
    if (!_grid[x][y].revealed) {
      _grid[x][y].flag = !(_grid[x][y].flag);
      notifyListeners();
    }
  }

  set width(int width) {
    this._width = width;
    switch (width) {
      case 4:
        _numberOfMines = 6;
        break;
      case 8:
        _numberOfMines = 18;
        break;
      case 10:
        _numberOfMines = 36;
        break;
      default:
        break;
    }
    initializeGrid();
  }

  int get width => _width;

  int get size => _width * _width;

  List<List<Cell>> get grid => [..._grid];

  List<List<Cell>> get _make2DList => List.generate(
      _width, (rowIndex) => List.generate(_width, (colIndex) => Cell()));
}
