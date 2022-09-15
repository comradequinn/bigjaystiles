import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import 'components/add_category_dialog.dart';
import 'components/category_list.dart';
import 'components/manage_categories_help_dialog.dart';

class ManageCategoriesView extends StatelessWidget {
  final CategoryList Function() _categoryList;
  final AddCategoryDialog Function() _addCategoryDialog;
  final ManageCategoriesHelpDialog Function() _helpDialog;

  ManageCategoriesView(Qinjector qinjector, {Key? key})
      : _categoryList =
            qinjector.use<ManageCategoriesView, CategoryList Function()>(),
        _addCategoryDialog =
            qinjector.use<ManageCategoriesView, AddCategoryDialog Function()>(),
        _helpDialog = qinjector
            .use<ManageCategoriesView, ManageCategoriesHelpDialog Function()>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Categories"),
          actions: [
            IconButton(
                onPressed: () =>
                    showDialog(context: context, builder: (_) => _helpDialog()),
                icon: const Icon(Icons.help))
          ],
        ),
        body: _categoryList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog<bool>(
                context: context, builder: (context) => _addCategoryDialog());
          },
          child: const Icon(Icons.add),
        ));
  }
}
