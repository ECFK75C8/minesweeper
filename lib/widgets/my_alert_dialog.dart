import 'package:flutter/material.dart';
import '../models/init_value.dart';

class AddDialog extends StatefulWidget {
  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  var _formKey = GlobalKey<FormState>();
  var widthController = TextEditingController(text: '0');
  var heightController = TextEditingController(text: '0');
  var minesController = TextEditingController(text: '0');

  void _submitButton() {
    if (_formKey.currentState.validate()) {
      var column = int.parse(widthController.text);
      var row = int.parse(heightController.text);
      var mines = int.parse(minesController.text);
      var result = InitValues(
        column: column,
        row: row,
        noOfMines: mines,
      );
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          child: Text('Ok'),
          onPressed: _submitButton,
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      title: Text('Settings'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Width:',
                  style: TextStyle(color: Colors.black54),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: widthController,
                      decoration: InputDecoration.collapsed(
                        hintText: '4 - 20',
                      ),
                      validator: (value) {
                        var result = int.parse(value);
                        if (result < 4 || result > 20)
                          return 'width must be between 4 - 20';
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'height:',
                  style: TextStyle(color: Colors.black54),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: TextFormField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: '4 - 20',
                      ),
                      validator: (value) {
                        var result = int.parse(value);
                        if (result < 4 || result > 20)
                          return 'height must be between 4 - 20';
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Number of mines:',
                  style: TextStyle(color: Colors.black54),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: TextFormField(
                      controller: minesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: '> 1 and <= grid size',
                      ),
                      validator: (value) {
                        var size = int.parse(widthController.text) *
                            int.parse(heightController.text);
                        if (int.parse(value) == 0)
                          return 'There must be at least one mine';
                        if (int.parse(value) > size)
                          return 'Number of mines must be less than or equal to grid size';
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
