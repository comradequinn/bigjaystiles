import 'package:bigjaystiles/tiles/db/tile_db.dart';
import 'package:bigjaystiles/tiles/tile_controller.dart';
import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import 'icon_picker/icon_picker.dart';

class AddCategoryDialog extends StatefulWidget {
  final TileController _tileController;
  final IconPicker Function() _iconPicker;

  AddCategoryDialog(Qinjector qinjector, {Key? key})
      : _tileController = qinjector.use<AddCategoryDialog, TileController>(),
        _iconPicker = qinjector.use<AddCategoryDialog, IconPicker Function()>(),
        super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  IconData? icon;
  var title = TextEditingController();
  var iconError = false;
  var titleError = false;

  @override
  Widget build(BuildContext context) {
    final tc = widget._tileController;

    return AlertDialog(
      title: const Text('Add Category'),
      content: SizedBox(
          height: 100,
          width: 500,
          child: Row(children: [
            GestureDetector(
                onTap: () async {
                  icon = await showDialog<IconData?>(
                      context: context,
                      builder: (context) => widget._iconPicker());

                  setState(() => iconError = icon == null);
                },
                child: Icon(
                    color: iconError ? Colors.red : null,
                    icon ?? Icons.search)),
            const SizedBox(width: 20),
            Expanded(
                child: TextField(
              controller: title,
              onChanged: (text) => {
                setState(() {
                  titleError = text.isEmpty;
                })
              },
              maxLength: TileDB.maximumCategoryTitleLength,
              autofocus: true,
              decoration: InputDecoration(
                errorText: titleError ? "Title required" : null,
                counterText: "",
                hintText: "Category title",
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
              ),
            ))
          ])),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              var i = icon;
              if (i != null && title.text.isNotEmpty) {
                tc.addCategory(title.text, i, false);
                Navigator.of(context).pop(true);
              } else {
                setState(() {
                  iconError = i == null;
                  titleError = title.text.isEmpty;
                });
              }
            },
            child: const Text('Add'))
      ],
    );
  }
}
