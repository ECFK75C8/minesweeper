import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_item.dart';

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.timer),
          SizedBox(
            width: 5,
          ),
          Consumer<TimerItem>(
            builder: (_, timerData, __) => Text(
              timerData.timerText,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
