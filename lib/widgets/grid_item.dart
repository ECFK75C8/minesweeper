import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final grid;
  final Offset offset;

  GridItem(this.grid, this.offset);

  Color _getColor(grid, x, y) {
    if (grid[x][y].flag) return Colors.green[600];
    if (grid[x][y].mine) return Colors.red[400];
    var count = grid[x][y].neighborsCount;
    if (count > 0) {
      switch (count) {
        case 1:
          return Colors.cyan[400];
          break;
        case 2:
          return Colors.cyan[200];
          break;
        case 3:
          return Colors.indigo[200];
          break;
        case 4:
          return Colors.indigo[600];
          break;
        case 5:
          return Colors.purple[200];
          break;
        case 6:
          return Colors.purple[600];
          break;
        default:
          return Colors.pink[400];
      }
    }
    return Colors.green[200];
  }

  Widget _displayItem(grid, x, y) {
    var getColor = _getColor(grid, x, y);
    if (grid[x][y].revealed && !(grid[x][y].flag)) {
      switch (grid[x][y].mine) {
        case true:
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: getColor),
            ),
            child: Image.asset('assets/${grid[x][y].bombName}.png'),
          );
          break;
        case false:
          var count = grid[x][y].neighborsCount;
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: getColor),
            ),
            child: Text(
              '${count == 0 ? '' : count}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        default:
          return SizedBox.shrink();
      }
    }
    if (grid[x][y].flag) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: getColor),
        ),
        child: Image.asset(
          'assets/${grid[x][y].flagName}.png',
          // fit: BoxFit.contain,
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) => GridTile(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(width: 4, color: Colors.black12),
          ),
          child: _displayItem(grid, offset.dx.toInt(), offset.dy.toInt()),
        ),
      );
}
