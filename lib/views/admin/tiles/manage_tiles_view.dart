import 'package:bigjaystiles/views/admin/tiles/components/manage_tiles_help_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import 'components/add_tile_dialog.dart';
import 'components/tile_list.dart';

class ManageTilesView extends StatelessWidget {
  final TileList Function() _tileList;
  final AddTileDialog Function() _addTileDialog;
  final ManageTilesHelpDialog Function() _helpDialog;

  ManageTilesView(Qinjector qinjector, {Key? key})
      : _tileList = qinjector.use<ManageTilesView, TileList Function()>(),
        _addTileDialog =
            qinjector.use<ManageTilesView, AddTileDialog Function()>(),
        _helpDialog =
            qinjector.use<ManageTilesView, ManageTilesHelpDialog Function()>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Tiles"),
          actions: [
            IconButton(
                onPressed: () =>
                    showDialog(context: context, builder: (_) => _helpDialog()),
                icon: const Icon(Icons.help))
          ],
        ),
        body: _tileList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog<bool>(
                context: context, builder: (context) => _addTileDialog());
          },
          child: const Icon(Icons.add),
        ));
  }
}
