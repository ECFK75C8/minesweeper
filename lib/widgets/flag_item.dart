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
            builder: (_, cellData, __) => Text(
              '${(cellData.flags > cellData.mines) ? cellData.mines : cellData.flags}/${cellData.mines}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
