import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_item.dart';
import '../providers/cell_item.dart' show CellItems;

class GameBody extends StatelessWidget {

  Widget _displayItem(grid, x, y) {
    if (grid[x][y].revealed && !(grid[x][y].flag)) {
      switch (grid[x][y].mine) {
        case true:
          return Icon(Icons.flare, color: grid[x][y].iconColor);
          break;
        case false:
          var count = grid[x][y].neighborsCount;
          return Text(
            '${count == 0 ? '' : count}',
            style: TextStyle(fontWeight: FontWeight.w600),
          );
        default:
          return SizedBox.shrink();
      }
    }
    if (grid[x][y].flag) {
      return Icon(
        Icons.flag,
        color: Colors.deepOrange,
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Consumer<CellItems>(
          builder: (_, cellData, child) => !(cellData.display)
              ? SizedBox.shrink()
              : 
              GridView.builder(
                  itemCount: cellData.size,
                  physics: NeverScrollableScrollPhysics(),
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
                            color: cellData.grid[x][y].revealed
                                ? Colors.black12
                                : Colors.white12,
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                          child: Center(
                            child: _displayItem(cellData.grid, x, y),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
