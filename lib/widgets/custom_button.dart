import 'package:flutter/material.dart';
import '../models/value.dart';

class CustomButton extends StatelessWidget {
  final int column;
  final int row;
  final int mines;
  CustomButton({this.column, this.row, this.mines});
  @override
  Widget build(BuildContext context) => FlatButton(
        color: Color.fromARGB(100, 200, 200, 200),
        onPressed: () {
          var result = Value(
            column: column,
            row: row,
            noOfMines: mines,
          );
          Navigator.of(context).pop(result);
        },
        child: Text(
          '$column x $row grid',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
