import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cell.dart';
import '../models/value.dart';

class CellItems extends ChangeNotifier {
  bool paused = false;
  bool started = false;
  bool gameOver = false;

  int _row = 0;
  int _column = 0;
  int _numberOfMines = 0;
  int _numberOfFlags = 0;
  List<List<Cell>> _grid;

  var offsets = <Offset>[
    Offset(-1, 0),
    Offset(-1, 1),
    Offset(-1, -1),
    Offset(0, -1),
    Offset(0, 1),
    Offset(1, -1),
    Offset(1, 0),
    Offset(1, 1)
  ];

  int get mines => _numberOfMines;

  int get flags => _numberOfFlags;

  int get width => _column;

  int get size => _row * _column;

  List<List<Cell>> get grid => [..._grid];

  bool get display => _column > 0;

  bool get win {
    if (gameOver) return false;
    var won = grid.fold<int>(
                0,
                (previousValue, element) =>
                    previousValue +
                    (element.fold<int>(
                        0,
                        (previousValue, element) =>
                            previousValue +
                            ((element.revealed && !element.mine) ? 1 : 0)))) +
            mines ==
        size;

    if (won) {
      _numberOfFlags = _numberOfMines;
      _stopGame(won);
    }

    return won;
  }

  List<List<Cell>> get _make2DList =>
      List.generate(_row, (_) => List.generate(_column, (colIndex) => Cell()));

  set values(Value value) {
    if (value == null) return;
    this._row = value.row;
    this._column = value.column;
    this._numberOfMines = value.noOfMines;
    initializeGrid();
  }

  void initializeGrid() {
    paused = false;
    started = false;
    gameOver = false;
    _numberOfFlags = 0;
    _grid = _make2DList;
    notifyListeners();
  }

  bool reveal(int x, int y) {
    if (!started) {
      _start(x, y);
      started = true;
    }

    if (!gameOver && _grid[x][y].mine) {
      _grid[x][y].bombName = 'redbomb';
      _stopGame();
      gameOver = true;
      return false;
    }

    _grid[x][y].revealed = true;
    notifyListeners();

    if (!gameOver && grid[x][y].neighborsCount == 0) {
      _floodFill(x, y);
    }
    return true;
  }

  void setFlag(int x, int y) {
    if (!_grid[x][y].revealed) {
      _grid[x][y].flag = !(_grid[x][y].flag);
      _grid[x][y].flag ? _numberOfFlags++ : _numberOfFlags--;
      _grid[x][y].flagName = (flags > mines) ? 'noflag' : 'flag';
      notifyListeners();
    }
  }

  void _start(int x, int y) {
    var options = <List<int>>[];
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
    }

    grid.asMap().forEach((rowIndex, row) => row
        .asMap()
        .forEach((colIndex, _) => _countNeighbors(rowIndex, colIndex)));
  }

  void _countNeighbors(int x, int y) {
    if (_grid[x][y].mine) {
      _grid[x][y].neighborsCount = -1;
      return;
    }

    var count = offsets.map((offset) {
      int i = x + offset.dx.toInt();
      int j = y + offset.dy.toInt();
      if (i > -1 && i < _row && j > -1 && j < _column) {
        return (_grid[i][j].mine) ? 1 : 0;
      }
      return 0;
    }).fold(0, (previousValue, element) => previousValue + element);

    _grid[x][y].neighborsCount = count;
  }

  void _floodFill(int x, int y) {
    offsets.forEach((offset) {
      int j = y + offset.dy.toInt();
      int i = x + offset.dx.toInt();

      if (i > -1 && i < _row && j > -1 && j < _column) {
        var neighbor = _grid[i][j];
        if (!neighbor.mine && !neighbor.revealed) {
          reveal(i, j);
        }
      }
    });
  }

  void _stopGame([bool won = false]) {
    grid
        .asMap()
        .forEach((rowIndex, row) => row.asMap().forEach((cellIndex, cell) {
              if (!cell.revealed) {
                _grid[rowIndex][cellIndex].revealed = true;
                if (won) _grid[rowIndex][cellIndex].flag = true;
              }
            }));

    notifyListeners();
  }
}
