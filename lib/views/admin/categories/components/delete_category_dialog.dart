import 'package:flutter/material.dart';

import '../../../../tiles/model.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final Category _category;

  const DeleteCategoryDialog(this._category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete '${_category.title}' Category?"),
      content: SingleChildScrollView(
          child: Text(
              '''Any tiles in this category will be set as 'unassigned' and no longer show in the main screen.

Tiles which are set as 'unassigned' can be assigned to a different category, or deleted, by selecting 'Manage Tiles' from the menu.

Are you sure you want to delete the category '${_category.title}'?
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
