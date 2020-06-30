import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/init_value.dart';
import '../widgets/game_body.dart';
import '../widgets/custom_button.dart';
import '../widgets/my_timer.dart';
import '../widgets/flag_item.dart';
import '../widgets/my_alert_dialog.dart';
import '../providers/timer_item.dart';
import '../providers/cell_item.dart';

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
      _showBottomDialog(context).then((result) => gridData.values = result);
    });
  }

  @override
  void dispose() async {
    super.dispose();
    timerData?.stop();
  }

  void showAddDialog(BuildContext context) {
    showDialog<InitValues>(context: context, builder: (_) => AddDialog())
        .then((result) {
      if (result != null) timerData.resetTimer();
      gridData.values = result;
    });
  }

  Future<InitValues> _showBottomDialog(BuildContext context) =>
      showModalBottomSheet<InitValues>(
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
                spacing: 5,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  CustomButton(column: 4, row: 4, mines: 6),
                  CustomButton(column: 8, row: 8, mines: 15),
                  CustomButton(column: 8, row: 10, mines: 20),
                  Container(
                    height: 36,
                    width: 36,
                    color: Color.fromARGB(100, 200, 200, 200),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        showAddDialog(context);
                      },
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
          FlagWidget(),
          TimerWidget(),
          PopupMenuButton(
            child: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == Selected.Reset) {
                timerData.resetTimer();
                gridData.initializeGrid();
              } else {
                _showBottomDialog(context).then((result) {
                  if (result != null) timerData.resetTimer();
                  gridData.values = result;
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
