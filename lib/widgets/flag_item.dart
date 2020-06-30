import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cell_item.dart';

class FlagWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, color: Colors.deepOrange),
          SizedBox(
            width: 5,
          ),
          Consumer<CellItems>(
            builder: (_, gridData, __) => Text(
              '${gridData.flags}/${gridData.mines}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
