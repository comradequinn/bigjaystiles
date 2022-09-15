import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '../model.dart';

class TileDBInitialiser {
  Future<void> init(
      List<Category> categories,
      List<Tile> tiles,
      File tileDataFile,
      File categoryDataFile,
      Directory imageDir,
      Directory audioDir) async {
    // reset any pre-existing/orphaned data files to a clean state
    if (await categoryDataFile.exists()) await categoryDataFile.delete();
    if (await imageDir.exists()) await imageDir.delete(recursive: true);
    if (await audioDir.exists()) await audioDir.delete(recursive: true);
    await imageDir.create();
    await audioDir.create();

    // load default categories from assets
    categories.addAll(List<Category>.from(json
        .decode(
            await rootBundle.loadString("assets/data/default/categories.json"))
        .map((data) => Category.fromJson(data))));

    // use default categories to seed local data file
    categoryDataFile.writeAsString(jsonEncode(categories));

    // load default tiles from assets. each default tile contains a partial
    //image path, update this to include the user & device's document dir
    tiles.addAll(List<Tile>.from(json
        .decode(await rootBundle.loadString("assets/data/default/tiles.json"))
        .map((data) => Tile.fromJson(data,
            imagePathPrefix: imageDir.path, audioPathPrefix: audioDir.path))));

    // use default tiles to seed local data file
    tileDataFile.writeAsString(jsonEncode(tiles));

    // copy the default images from the asset bundle into the image dir
    for (var t in tiles) {
      var sourceAssetImage = await rootBundle
          .load("assets/images/default/${p.basename(t.image.path)}");

      var sourceAssetAudio = await rootBundle
          .load("assets/audio/default/${p.basename(t.audio.path)}");

      await (await File(t.image.path).create(recursive: true))
          .writeAsBytes(Uint8List.view(sourceAssetImage.buffer));

      await (await File(t.audio.path).create(recursive: true))
          .writeAsBytes(Uint8List.view(sourceAssetAudio.buffer));
    }
  }
}
