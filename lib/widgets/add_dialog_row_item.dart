import 'package:flutter/material.dart';

class DialogRowItem extends StatelessWidget {
  final String label;
  final String hintText;
  final Function validator;
  final FocusNode focusNode;
  final Function onSubmitted;
  final Function onTap;
  final inputAction;
  final TextEditingController controller;

  const DialogRowItem({
    Key key,
    @required this.label,
    @required this.hintText,
    @required this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onTap,
    this.inputAction,
    @required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(color: Colors.black54),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: (focusNode.hasFocus)
                            ? Theme.of(context).accentColor
                            : Colors.black54))),
            child: TextFormField(
                keyboardType: TextInputType.number,
                controller: controller,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                ),
                textInputAction: inputAction,
                focusNode: focusNode,
                onFieldSubmitted: onSubmitted,
                validator: validator,
                onTap: onTap,
                ),
                
          ),
        ),
      ],
    );
  }
}
