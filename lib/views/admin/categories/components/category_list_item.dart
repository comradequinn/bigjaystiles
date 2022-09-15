import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../../../../tiles/db/tile_db.dart';
import '../../../../tiles/model.dart';
import '../../../../tiles/tile_controller.dart';
import '../../../components/icon_picker/icon_picker.dart';
import 'delete_category_dialog.dart';

class CategoryListItem extends StatefulWidget {
  final Category _category;
  final TileController _tileController;
  final DeleteCategoryDialog Function(Category) _deleteCategoryDialog;

  CategoryListItem(Qinjector qinjector, this._category, {Key? key})
      : _tileController = qinjector.use<CategoryListItem, TileController>(),
        _deleteCategoryDialog = qinjector
            .use<CategoryListItem, DeleteCategoryDialog Function(Category)>(),
        super(key: key);

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  BoxDecoration? border;
  var editing = false;
  final titleInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tc = widget._tileController;
    var category = widget._category;

    reOrder(bool upward) async {
      setState(() {
        border = BoxDecoration(
          border: upward
              ? const Border(top: BorderSide(color: Colors.black12))
              : const Border(bottom: BorderSide(color: Colors.black12)),
        );
      });

      final categoryIdx = tc.categories().indexOf(category);
      final relativeToIdx = upward ? categoryIdx - 1 : categoryIdx + 1;

      await tc.swapCategories(
          category, tc.categories().elementAt(relativeToIdx));

      await Future.delayed(const Duration(milliseconds: 250),
          () => setState(() => border = null));
    }

    List<Widget> children = [];

    children.add(GestureDetector(
      onTap: () async {
        var iconData = await showDialog<IconData?>(
            context: context, builder: (context) => IconPicker());

        if (iconData != null) {
          await tc
              .updateCategory(Category(category.id, category.title, iconData));
        }
      },
      child: Icon(widget._category.icon),
    ));

    children.add(const SizedBox(width: 15));

    if (editing) {
      titleInput.text = category.title;

      children.add(Expanded(
          child: TextField(
        controller: titleInput,
        maxLength: TileDB.maximumCategoryTitleLength,
        autofocus: true,
        decoration: const InputDecoration(
          counterText: "",
          isDense: true,
          contentPadding: EdgeInsets.all(8),
          //border: OutlineInputBorder(),
        ),
      )));
      children.add(GestureDetector(
          onTap: () async {
            if (titleInput.text.isNotEmpty) {
              await tc.updateCategory(
                  Category(category.id, titleInput.text, category.icon));
              setState(() {
                editing = false;
              });
            }
          },
          child: const Icon(Icons.check)));

      children.add(const SizedBox(width: 20));

      children.add(GestureDetector(
          onTap: () {
            setState(() {
              editing = false;
            });
          },
          child: const Icon(Icons.cancel)));
    } else {
      children.add(Expanded(child: Text(category.title)));

      children.add(GestureDetector(
          onTap: () {
            setState(() {
              editing = true;
            });
          },
          child: const Icon(Icons.edit)));

      children.add(const SizedBox(width: 20));

      if (tc.categories().first != category && tc.categories().length > 1) {
        children.add(GestureDetector(
            onTap: () async {
              await reOrder(true);
            },
            child: const Icon(Icons.arrow_drop_up)));
      } else {
        children.add(const SizedBox(width: 23));
      }

      if (tc.categories().last != category && tc.categories().length > 1) {
        children.add(GestureDetector(
            onTap: () async {
              await reOrder(false);
            },
            child: const Icon(Icons.arrow_drop_down)));
      } else {
        children.add(const SizedBox(width: 23));
      }

      children.add(const SizedBox(width: 20));

      children.add(GestureDetector(
          onTap: () async {
            if (await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        widget._deleteCategoryDialog(category)) ==
                true) {
              tc.deleteCategory(category);
            }
          },
          child: const Icon(Icons.delete)));
    }

    return Container(
        decoration: border, child: ListTile(title: Row(children: children)));
  }
}
