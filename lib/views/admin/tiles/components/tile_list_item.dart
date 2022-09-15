import 'dart:io';

import 'package:bigjaystiles/views/admin/tiles/components/new_image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../../../../tiles/db/tile_db.dart';
import '../../../../tiles/model.dart';
import '../../../../tiles/tile_controller.dart';
import 'delete_tile_dialog.dart';
import 'new_audio_dialog.dart';

class TileListItem extends StatefulWidget {
  final Tile _tile;
  final Category _parentCategory;
  final DeleteTileDialog Function(Tile) _deleteTileDialog;
  final NewImageDialog Function(File?) _newImageDialog;
  final NewAudioDialog Function(File?) _newAudioDialog;
  final TileController _tileController;

  TileListItem(Qinjector qinjector, this._tile, this._parentCategory,
      {Key? key})
      : _tileController = qinjector.use<TileListItem, TileController>(),
        _deleteTileDialog =
            qinjector.use<TileListItem, DeleteTileDialog Function(Tile)>(),
        _newImageDialog =
            qinjector.use<TileListItem, NewImageDialog Function(File?)>(),
        _newAudioDialog =
            qinjector.use<TileListItem, NewAudioDialog Function(File?)>(),
        super(key: key);

  @override
  State<TileListItem> createState() => _TileListItemState();
}

class _TileListItemState extends State<TileListItem> {
  BoxDecoration? border;
  var editing = false;
  final titleInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tc = widget._tileController;
    var tile = widget._tile;
    var parentCategory = widget._parentCategory;

    reOrder(bool upward) async {
      setState(() {
        border = BoxDecoration(
          border: upward
              ? const Border(top: BorderSide(color: Colors.black12))
              : const Border(bottom: BorderSide(color: Colors.black12)),
        );
      });

      final tileIdx = tc.tiles(parentCategory).indexOf(tile);
      final relativeToIdx = upward ? tileIdx - 1 : tileIdx + 1;

      await tc.swapTiles(
          tile, tc.tiles(parentCategory).elementAt(relativeToIdx));

      await Future.delayed(const Duration(milliseconds: 250),
          () => setState(() => border = null));
    }

    List<Widget> children = [];

    children.add(GestureDetector(
      onTap: () async {
        final image = await showDialog<File?>(
            context: context,
            builder: (context) => widget._newImageDialog(tile.image));

        if (image != null && image != tile.image) {
          await tc.writeImage(image);
          tile.image = image;
          await tc.updateTile(tile);
        }
      },
      child: SizedBox(height: 30, width: 30, child: Image.file(tile.image)),
    ));

    children.add(const SizedBox(width: 15));

    if (editing) {
      titleInput.text = tile.title;

      children.add(Expanded(
          child: TextField(
        controller: titleInput,
        maxLength: TileDB.maximumTileTitleLength,
        autofocus: true,
        decoration: const InputDecoration(
          counterText: "",
          isDense: true,
          contentPadding: EdgeInsets.all(8),
        ),
      )));
      children.add(GestureDetector(
          onTap: () async {
            if (titleInput.text.isNotEmpty) {
              await tc.updateTile(Tile(tile.id, titleInput.text, tile.image,
                  tile.audio, tile.categoryID));
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
      children.add(Expanded(child: Text(tile.title)));

      children.add(GestureDetector(
          onTap: () {
            setState(() {
              editing = true;
            });
          },
          child: const Icon(Icons.edit)));

      children.add(const SizedBox(width: 20));

      children.add(GestureDetector(
        onTap: () async {
          final audioFile = await showDialog<File?>(
              context: context,
              builder: (context) => widget._newAudioDialog(tile.audio));

          if (audioFile != null && audioFile != tile.audio) {
            tile.audio = await tc.writeAudio(audioFile);
            tc.updateTile(tile);
          }
        },
        child: const SizedBox(
            height: 30,
            width: 30,
            child: Icon(Icons.record_voice_over_outlined)),
      ));

      children.add(const SizedBox(width: 15));

      if (tc.tiles(parentCategory).first != tile &&
          tc.tiles(parentCategory).length > 1) {
        children.add(GestureDetector(
            onTap: () async {
              await reOrder(true);
            },
            child: const Icon(Icons.arrow_drop_up)));
      } else {
        children.add(const SizedBox(width: 23));
      }

      if (tc.tiles(parentCategory).last != tile &&
          tc.tiles(parentCategory).length > 1) {
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
                    builder: (context) => widget._deleteTileDialog(tile)) ==
                true) {
              tc.deleteTile(tile);
            }
          },
          child: const Icon(Icons.delete)));
    }

    final listTile = ListTile(title: Row(children: children));

    final dragFeedback = Row(children: [
      SizedBox(
          height: 60,
          width: 300,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(
                    width: 2.5,
                    color: Colors.black12,
                  )),
              child: Row(children: [
                const SizedBox(width: 20),
                SizedBox(height: 40, width: 50, child: Image.file(tile.image)),
                const SizedBox(width: 20),
                Expanded(child: Text(tile.title)),
              ])))
    ]);

    return Container(
        decoration: border,
        child: editing
            ? listTile
            : LongPressDraggable<Tile>(
                data: tile,
                dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: dragFeedback,
                child: listTile));
  }
}
