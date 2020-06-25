import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/game_body.dart';
import '../widgets/custom_button.dart';
import '../widgets/my_timer.dart';
import '../providers/timer_item.dart';
import '../providers/cell_item.dart' show CellItems;

enum Selected { Reset, Change }

class GameHomeScreen extends StatefulWidget {
  @override
  _GameHomeScreenState createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  CellItems gridData;
  TimerItem timerData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      gridData = context.read<CellItems>();
      timerData = context.read<TimerItem>();
      _showBottomDialog(context).then((result) => gridData.width = result ?? 0);
    });
  }

  @override
  void dispose() async {
    super.dispose();
    timerData?.stop();
  }

  Future<int> _showBottomDialog(BuildContext context) =>
      showModalBottomSheet<int>(
        context: context,
        builder: (_) => Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select difficulty level.',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                children: <Widget>[
                  CustomButton(4),
                  CustomButton(8),
                  CustomButton(10),
                  Container(
                    height: 40,
                    width: 40,
                    color: Color.fromARGB(100, 200, 200, 200),
                    child: InkWell(
                      onTap: () {},
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minesweeper'),
        actions: <Widget>[
          TimerWidget(),
          PopupMenuButton(
            child: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == Selected.Reset) {
                timerData.resetTimer();
                gridData.initializeGrid();
              } else {
                _showBottomDialog(context).then((result) {
                  timerData.resetTimer();
                  gridData.width = result ?? 0;
                });
              }
            },
            itemBuilder: (_) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  child: Text('Reset'),
                  value: Selected.Reset,
                ),
                PopupMenuItem(
                  child: Text('Change difficulty'),
                  value: Selected.Change,
                )
              ];
            },
          )
        ],
      ),
      body: GameBody(),
    );
  }
}
