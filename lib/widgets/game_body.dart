import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_item.dart';
import '../providers/cell_item.dart' show CellItems;

class GameBody extends StatelessWidget {
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
          Icons.flag,
          color: Colors.deepOrange,
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CellItems>(
      builder: (_, cellData, child) => !(cellData.display)
          ? SizedBox.shrink()
          : GridView.builder(
              addAutomaticKeepAlives: true,
              itemCount: cellData.size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cellData.width,
              ),
              itemBuilder: (_, index) {
                var x = (index / cellData.width).floor();
                var y = (index % cellData.width);
                return InkWell(
                  onTap: () {
                    if (!cellData.grid[x][y].flag) {
                      if (!cellData.started)
                        context.read<TimerItem>().startTimer();
                      var result = cellData.reveal(x, y);
                      if (!result) context.read<TimerItem>().stop();
                    }
                  },
                  onLongPress: () {
                    cellData.setFlag(x, y);
                  },
                  child: GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(width: 4, color: Colors.black12),
                      ),
                      child: _displayItem(cellData.grid, x, y),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
