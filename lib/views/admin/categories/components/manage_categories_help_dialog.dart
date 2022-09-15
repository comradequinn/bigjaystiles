import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../../_shared/help_dialog.dart';

class ManageCategoriesHelpDialog extends StatelessWidget {
  final HelpDialog Function(String, List<HelpRow>) _helpDialog;

  ManageCategoriesHelpDialog(Qinjector qinject, {super.key})
      : _helpDialog = qinject.use<ManageCategoriesHelpDialog,
            HelpDialog Function(String, List<HelpRow>)>();

  final helpRows = const <HelpRow>[
    HelpRow("Change icon", Icons.image),
    HelpRow("Edit title", Icons.edit),
    HelpRow("Change order", Icons.arrow_drop_down),
    HelpRow("Change order", Icons.arrow_drop_up),
    HelpRow("Delete", Icons.delete),
    HelpRow("Add new", Icons.add),
  ];

  @override
  Widget build(BuildContext context) => _helpDialog("Categories", helpRows);
}
