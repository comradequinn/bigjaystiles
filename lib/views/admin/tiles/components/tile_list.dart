import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../../../../tiles/model.dart';
import '../../../../tiles/tile_controller.dart';
import 'tile_list_item.dart';

class TileList extends StatelessWidget {
  final TileController _tileController;
  final TileListItem Function(Tile t, Category c) _tileListItem;

  TileList(Qinjector qinjector, {Key? key})
      : _tileController = qinjector.use<TileList, TileController>(),
        _tileListItem = qinjector
            .use<TileList, TileListItem Function(Tile t, Category c)>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _tileController.changeNotifier,
      builder: (context, value, child) {
        final listItems = List<Widget>.empty(growable: true);

        for (var category in _tileController.categories(includeHidden: true)) {
          final tiles = _tileController.tiles(category);
          final tilesInCategory = List<Widget>.empty(growable: true);

          for (var tile in tiles) {
            tilesInCategory.add(_tileListItem(tile, category));
          }

          listItems.add(DragTarget<Tile>(onAccept: (tile) {
            if (tile.categoryID != category.id) {
              tile.categoryID = category.id;
              _tileController.updateTile(tile);
            }
          }, builder: (_, draggedTiles, ___) {
            var text = category.title;

            if (draggedTiles.isNotEmpty) {
              final draggedTile = draggedTiles[0];

              if (draggedTile != null) {
                if (draggedTile.categoryID == category.id) {
                  text =
                      "Drag to move '${draggedTiles[0]!.title}' to another category";
                } else {
                  text =
                      "Drop to move '${draggedTiles[0]!.title}' to '${category.title}'";
                }
              }
            }

            return ExpansionTile(
                initiallyExpanded: true,
                title: Text(text),
                children: tilesInCategory);
          }));
        }

        return ListView(
          children: listItems,
        );
      },
    );
  }
}
