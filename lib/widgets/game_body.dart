import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets/grid_item.dart';
import '../providers/timer_item.dart';
import '../providers/cell_item.dart' show CellItems;

class GameBody extends StatelessWidget {
  void _showAlert(BuildContext context) {
    var time = context.read<TimerItem>().timerText;
    Alert(
      context: context,
      title: "WON!!!",
      desc: "You have cleared the mine field in $time.",
      type: AlertType.info,
      style: AlertStyle(isOverlayTapDismiss: false),
    ).show();
  }

  @override
  Widget build(BuildContext context) => Consumer<CellItems>(
        builder: (_, cellData, __) => (!cellData.display)
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
                      if (cellData.paused) {
                        cellData.paused = false;
                        context.read<TimerItem>().startTimer();
                      }

                      if (!cellData.grid[x][y].flag) {
                        if (!cellData.started)
                          context.read<TimerItem>().startTimer();

                        if (!cellData.reveal(x, y))
                          context.read<TimerItem>().stop();

                        if (!cellData.grid[x][y].mine && cellData.win) {
                          context.read<TimerItem>().stop();
                          _showAlert(context);
                        }
                      }
                    },
                    onLongPress: () {
                      if (cellData.paused) {
                        cellData.paused = false;
                        context.read<TimerItem>().startTimer();
                      }

                      cellData.setFlag(x, y);
                    },
                    child: GridItem(
                        cellData.grid, Offset(x.toDouble(), y.toDouble())),
                  );
                },
              ),
      );
}
