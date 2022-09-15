import 'dart:io';

import 'package:bigjaystiles/tiles/db/tile_db.dart';
import 'package:bigjaystiles/tiles/model.dart';
import 'package:bigjaystiles/tiles/tile_controller.dart';
import 'package:bigjaystiles/views/admin/tiles/components/new_image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import 'new_audio_dialog.dart';

class AddTileDialog extends StatefulWidget {
  final TileController _tileController;
  final NewImageDialog Function(File?) _newImageDialog;
  final NewAudioDialog Function(File?) _newAudioDialog;

  AddTileDialog(Qinjector qinjector, {Key? key})
      : _tileController = qinjector.use<AddTileDialog, TileController>(),
        _newImageDialog =
            qinjector.use<AddTileDialog, NewImageDialog Function(File?)>(),
        _newAudioDialog =
            qinjector.use<AddTileDialog, NewAudioDialog Function(File?)>(),
        super(key: key);

  @override
  State<AddTileDialog> createState() => _AddTileDialogState();
}

class _AddTileDialogState extends State<AddTileDialog> {
  File? _image;
  File? _audio;
  var title = TextEditingController();
  var imageError = false;
  var audioError = false;
  var titleError = false;

  @override
  Widget build(BuildContext context) {
    final tc = widget._tileController;

    return AlertDialog(
      title: const Text('Add Tile'),
      content: SizedBox(
          height: 100,
          width: 500,
          child: Row(children: [
            GestureDetector(
                onTap: () async {
                  _image = await showDialog<File?>(
                      context: context,
                      builder: (context) => widget._newImageDialog(null));

                  setState(() => imageError = _image == null);
                },
                child: _image != null
                    ? Image.file(
                        _image!,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: imageError ? Colors.red : Colors.grey),
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.camera_alt,
                        ))),
            const SizedBox(width: 20),
            Expanded(
                child: TextField(
              controller: title,
              onChanged: (text) => {
                setState(() {
                  titleError = text.isEmpty;
                })
              },
              maxLength: TileDB.maximumTileTitleLength,
              autofocus: true,
              decoration: InputDecoration(
                errorText: titleError ? "Title required" : null,
                counterText: "",
                hintText: "Tile title",
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
              ),
            )),
            const SizedBox(width: 20),
            GestureDetector(
                onTap: () async {
                  _audio = await showDialog<File?>(
                      context: context,
                      builder: (context) => widget._newAudioDialog(null));

                  setState(() => audioError = _audio == null);
                },
                child: Container(
                    decoration:
                        BoxDecoration(color: audioError ? Colors.red : null),
                    height: 30,
                    width: 30,
                    child: const Icon(
                        color: Colors.black54,
                        Icons.record_voice_over_outlined))),
          ])),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () async {
              var i = _image;
              var a = _audio;

              if (i != null && a != null && title.text.isNotEmpty) {
                await tc.addTile(title.text, await tc.writeImage(i),
                    await tc.writeAudio(a), Category.unassigned);
                if (!mounted) return;
                Navigator.of(context).pop(true);
              } else {
                setState(() {
                  imageError = i == null;
                  audioError = a == null;
                  titleError = title.text.isEmpty;
                });
              }
            },
            child: const Text('Add'))
      ],
    );
  }
}
