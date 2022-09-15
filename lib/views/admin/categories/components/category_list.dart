import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../../../../tiles/model.dart';
import '../../../../tiles/tile_controller.dart';
import 'category_list_item.dart';

class CategoryList extends StatelessWidget {
  final TileController _tileController;
  final CategoryListItem Function(Category) _categoryListItem;

  CategoryList(Qinjector qinjector, {Key? key})
      : _tileController = qinjector.use<CategoryList, TileController>(),
        _categoryListItem =
            qinjector.use<CategoryList, CategoryListItem Function(Category)>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _tileController.changeNotifier,
      builder: (context, value, child) {
        if (_tileController.categories().isEmpty) {
          return const Center(child: Text("No categories have been added"));
        }

        var listItems = List<Widget>.empty(growable: true);

        for (var category in _tileController.categories()) {
          listItems.add(_categoryListItem(category));
        }

        return ListView(
          children: listItems,
        );
      },
    );
  }
}
