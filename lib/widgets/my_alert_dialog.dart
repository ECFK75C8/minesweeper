import 'package:flutter/material.dart';
import '../widgets/add_dialog_row_item.dart';
import '../models/value.dart';

class AddDialog extends StatefulWidget {
  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final _rowFocusNode = FocusNode();
  final _minesFocusNode = FocusNode();
  final _columnFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _rowController = TextEditingController();
  final _minesController = TextEditingController();
  final _columnController = TextEditingController();

  void _submitButton() {
    if (_formKey.currentState.validate()) {
      var row = int.parse(_rowController.text);
      var mines = int.parse(_minesController.text);
      var column = int.parse(_columnController.text);
      var result = Value(
        row: row,
        column: column,
        noOfMines: mines,
      );
      Navigator.of(context).pop(result);
    }
  }

  void _onTap() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
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
        title: Text('Set values'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogRowItem(
                label: 'Rows',
                hintText: '4 - 20',
                focusNode: _rowFocusNode,
                controller: _rowController,
                inputAction: TextInputAction.next,
                onTap: _onTap,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_columnFocusNode);
                  setState((){});
                },
                validator: (value) {
                  var result = int.tryParse(value) ?? 0;
                  if (result < 4 || result > 20)
                    return 'row must be between 4 - 20';
                  return null;
                },
              ),
              SizedBox(height: 10),
              DialogRowItem(
                label: 'Columns',
                hintText: '4 - 20',
                focusNode: _columnFocusNode,
                controller: _columnController,
                inputAction: TextInputAction.next,
                onTap: _onTap,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_minesFocusNode);
                  setState((){});
                },
                validator: (value) {
                  var result = int.tryParse(value) ?? 0;
                  if (result < 4 || result > 20)
                    return 'column must be between 4 - 20';
                  return null;
                },
              ),
              SizedBox(height: 10),
              DialogRowItem(
                label: 'mines',
                hintText: '> 1 and <= grid size',
                focusNode: _minesFocusNode,
                controller: _minesController,
                inputAction: TextInputAction.done,
                onTap: _onTap,
                onSubmitted: (_) => _submitButton(),
                validator: (String value) {
                  var column = _columnController.text.isNotEmpty
                      ? _columnController.text
                      : '0';
                  var row = _rowController.text.isNotEmpty
                      ? _rowController.text
                      : '0';

                  value = value.isNotEmpty ? value : '0';

                  try {
                    var size = int.parse(row) * int.parse(column);
                    if (int.parse(value) == 0 || value.isEmpty)
                      return 'There must be at least one mine';
                    if (int.parse(value) > size)
                      return 'Number of mines must be less than or equal to grid size';
                  } catch (e) {
                    return 'invalid value';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
