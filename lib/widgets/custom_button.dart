import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final int width;
  CustomButton(this.width);
  @override
  Widget build(BuildContext context) => FlatButton(
        color: Color.fromARGB(100, 200, 200, 200),
        onPressed: () {
          Navigator.of(context).pop(width);
        },
        child: Text(
          '$width x $width grid',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
