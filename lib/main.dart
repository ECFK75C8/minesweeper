import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/cell_item.dart';
import './providers/timer_item.dart';
import './screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CellItems(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerItem(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minesweeper',
        home: GameHomeScreen(),
      ),
    );
  }
}
