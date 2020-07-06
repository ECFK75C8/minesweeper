import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final grid;
  final Offset offset;

  GridItem(this.grid, this.offset);

  Color _getColor(grid, x, y) {
    if (grid[x][y].flag) return Colors.indigoAccent;
    if (grid[x][y].mine) return Colors.indigo;
    var count = grid[x][y].neighborsCount;
    if (count > 0) {
      switch (count) {
        case 1:
        case 2:
          return Colors.blue;
          break;
        case 3:
        case 4:
          return Colors.cyan;
          break;
        case 5:
        case 6:
          return Colors.pinkAccent;
          break;
        default:
          return Colors.pink;
          break;
      }
    }
    return Colors.orangeAccent;
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
            child: Icon(Icons.flare, color: grid[x][y].iconColor),
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
        child: Icon(
          grid[x][y].flagIcon,
          color: Colors.deepOrange,
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
          child: _displayItem(grid, offset.dx, offset.dy),
        ),
      );
}
