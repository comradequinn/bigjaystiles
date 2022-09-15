import 'package:flutter/material.dart';

import '../../../../tiles/model.dart';

class DeleteTileDialog extends StatelessWidget {
  final Tile _tile;

  const DeleteTileDialog(this._tile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete '${_tile.title}' Tile?"),
      content: SingleChildScrollView(
          child: Text(
              '''This action cannot be undone. If you are unsure, you can hide the tile by changing the category to 'unassigned'.

Are you sure you want to delete the '${_tile.title}' tile?
''')),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'))
      ],
    );
  }
}
