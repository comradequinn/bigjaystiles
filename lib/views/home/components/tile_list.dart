import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qinject/qinject.dart';

import '../../../tiles/model.dart';
import 'tile_list_item.dart';

class TileList extends StatefulWidget {
  final TileReader _tileReader;
  final TileListItem Function(Tile, Category, double, double) _tileListItem;
  final Category? _targetCategory;
  final MediaQueryData Function(BuildContext) _mediaQuery;

  TileList(Qinjector qinjector, this._targetCategory, {Key? key})
      : _tileReader = qinjector.use<TileList, TileReader>(),
        _tileListItem = qinjector.use<TileList,
            TileListItem Function(Tile, Category, double, double)>(),
        _mediaQuery =
            qinjector.use<TileList, MediaQueryData Function(BuildContext)>(),
        super(key: key);

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  Tile? selectedTile;

  @override
  Widget build(BuildContext context) {
    var tc = widget._tileReader;
    final mediaQuery = widget._mediaQuery;

    if (tc.categories().isEmpty) {
      return const Center(child: Text("No tiles have been added"));
    }

    var targetCategory = widget._targetCategory;

    // if the current category has not yet been selected or has been deleted by the user after selection, then default it to the first category
    targetCategory =
        targetCategory == null || !tc.categories().contains(targetCategory)
            ? tc.categories().elementAt(0)
            : targetCategory;

    final tiles = tc.tiles(targetCategory);

    if (tiles.isEmpty) {
      return const Center(
          child: Text("No tiles have been added to this category"));
    }

    final tileWidth = ((mediaQuery(context).orientation == Orientation.landscape
                ? mediaQuery(context).size.height
                : mediaQuery(context).size.width) /
            2) *
        .9;

    final categories = tc.categories();
    List<Widget> tileListItems = [];

    for (var tile in tiles) {
      tileListItems.add(widget._tileListItem(
          tile,
          categories.firstWhere((c) => c.id == tile.categoryID),
          tileWidth,
          tileWidth * .8));
    }

    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Wrap(
                runSpacing: 10,
                spacing: 10,
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.spaceAround,
                children: tileListItems)));
  }
}
