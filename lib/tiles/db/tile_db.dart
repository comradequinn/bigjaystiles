import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

import '../model.dart';
import 'tile_db_initialiser.dart';

class TileDB {
  static const int maximumCategories = 8;
  static const int maximumTileTitleLength = 20;
  static const int maximumCategoryTitleLength = 12;
  static const Uuid _uuid = Uuid();
  final File _tileDataFile;
  final File _categoryDataFile;
  final Directory _imageDir;
  final Directory _audioDir;
  final List<Category> _categories;
  final List<Tile> _tiles;

  TileDB._(this._tileDataFile, this._categoryDataFile, this._imageDir,
      this._audioDir, this._categories, this._tiles);

  static Future<TileDB> open(
      TileDBInitialiser tileDBInitialiser, String dataDirectory) async {
    final tileDataFile = File("$dataDirectory/tiles.json");
    final categoryDataFile = File("$dataDirectory/categories.json");
    final imageDir = Directory("$dataDirectory/images/");
    final audioDir = Directory("$dataDirectory/audio/");

    final List<Category> categories = [];
    final List<Tile> tiles = [];

    if (!await tileDataFile.exists() ||
        !await categoryDataFile.exists() ||
        !await imageDir.exists() ||
        !await audioDir.exists()) {
      await tileDBInitialiser.init(categories, tiles, tileDataFile,
          categoryDataFile, imageDir, audioDir);
    } else {
      categories.addAll(List<Category>.from(json
          .decode(await categoryDataFile.readAsString())
          .map((data) => Category.fromJson(data))));

      tiles.addAll(List<Tile>.from(json
          .decode(await tileDataFile.readAsString())
          .map((data) => Tile.fromJson(data))));
    }

    return TileDB._(
        tileDataFile, categoryDataFile, imageDir, audioDir, categories, tiles);
  }

  List<Tile> tiles() => List.unmodifiable(_tiles.map((t) => t.clone()));

  List<Category> categories() =>
      List.unmodifiable(_categories.map((c) => c.clone()));

  Future<Tile> addTile(
      String title, File image, File audio, int categoryID) async {
    if (title.isEmpty ||
        title.length > maximumTileTitleLength ||
        _tiles.any((t) => t.title.toLowerCase() == title.toLowerCase())) {
      throw InputValidationException(
          "tile requires a non-empty, unique title which is under $maximumTileTitleLength characters in length");
    }

    final newID = _tiles
            .reduce((max, current) => current.id > max.id ? current : max)
            .id +
        1;

    final t = Tile(newID, title, image, audio, categoryID);
    _tiles.insert(0, t);

    await _tileDataFile.writeAsString(jsonEncode(_tiles));

    return t.clone();
  }

  Future<void> updateTile(Tile tile) async {
    if (tile.title.isEmpty || tile.title.length > maximumTileTitleLength) {
      throw InputValidationException(
          "tile requires a non-empty title which is under $maximumTileTitleLength characters in length");
    }

    final currentTile = _tiles.firstWhere((t) => t.id == tile.id);
    Future<FileSystemEntity>? imageDeleteFuture;

    if (currentTile.image != tile.image) {
      imageDeleteFuture = currentTile.image.delete();
    }

    final idx = _tiles.indexOf(currentTile);
    _tiles.remove(currentTile);
    _tiles.insert(idx, tile.clone());

    await _tileDataFile.writeAsString(jsonEncode(_tiles));
    if (imageDeleteFuture != null) await imageDeleteFuture;
  }

  Future<void> swapTiles(Tile tileA, Tile tileB) async {
    if (tileA == tileB) {
      throw ArgumentError("swapTiles expects different tiles as inputs");
    }

    var idxA = _tiles.indexOf(tileA);
    var idxB = _tiles.indexOf(tileB);
    List<Tile> tiles = [];

    for (var i = 0; i < _tiles.length; i++) {
      var idx = i;
      if (i == idxA) idx = idxB;
      if (i == idxB) idx = idxA;

      tiles.add(_tiles.elementAt(idx));
    }

    _tiles.clear();
    _tiles.addAll(tiles);

    await _tileDataFile.writeAsString(jsonEncode(_tiles));
  }

  Future<void> deleteTile(Tile t) async {
    final imageDeletedFuture = t.image.delete();
    _tiles.remove(t);

    await _tileDataFile.writeAsString(jsonEncode(_tiles));
    await imageDeletedFuture;
  }

  Future<Category> addCategory(String title, IconData icon, bool hidden) async {
    if (title.isEmpty ||
        title.length > maximumCategoryTitleLength ||
        _categories.any((c) => c.title.toLowerCase() == title.toLowerCase())) {
      throw ArgumentError(
          "category requires a non-empty, unique title which is under $maximumCategoryTitleLength characters in length");
    }

    if (_categories.length == maximumCategories) {
      ArgumentError(
          "the maximum number of permitted categories is $maximumCategories");
    }

    final newID = _categories
            .reduce((max, current) => current.id > max.id ? current : max)
            .id +
        1;

    final c = Category(newID, title, icon, hidden: hidden);
    _categories.add(c);

    await _categoryDataFile.writeAsString(jsonEncode(_categories));

    return c.clone();
  }

  Future<void> updateCategory(Category category) async {
    if (category.title.isEmpty ||
        category.title.length > maximumCategoryTitleLength ||
        _categories.any((c) =>
            c.id != category.id &&
            c.title.toLowerCase() == category.title.toLowerCase())) {
      throw ArgumentError(
          "category requires a non-empty, unique title which is under $maximumCategoryTitleLength characters in length");
    }

    var idx = _categories.indexOf(category);
    _categories.remove(category);
    _categories.insert(idx, category);

    await _categoryDataFile.writeAsString(jsonEncode(_categories));
  }

  Future<void> swapCategories(Category categoryA, Category categoryB) async {
    if (categoryA == categoryB) {
      throw ArgumentError(
          "swapCategories expects different categories as inputs");
    }

    var idxA = _categories.indexOf(categoryA);
    var idxB = _categories.indexOf(categoryB);
    List<Category> categories = [];

    for (var i = 0; i < _categories.length; i++) {
      var idx = i;
      if (i == idxA) idx = idxB;
      if (i == idxB) idx = idxA;

      categories.add(_categories.elementAt(idx));
    }

    _categories.clear();
    _categories.addAll(categories);

    await _categoryDataFile.writeAsString(jsonEncode(_categories));
  }

  Future<void> deleteCategory(Category c) async {
    for (var t in _tiles) {
      if (t.categoryID == c.id) {
        t.categoryID = Category.unassigned;
      }
    }

    await _tileDataFile.writeAsString(jsonEncode(_tiles));

    _categories.remove(c);

    await _categoryDataFile.writeAsString(jsonEncode(_categories));
  }

  Future<File> writeImage(File source) async {
    var destinationImagePath =
        "${_imageDir.path}${_uuid.v4()}.${p.extension(source.path)}";

    return await File(destinationImagePath)
        .writeAsBytes(await source.readAsBytes());
  }

  Future<File> writeAudio(File source) async {
    var destinationAudioPath =
        "${_audioDir.path}${_uuid.v4()}.${p.extension(source.path)}";

    return await File(destinationAudioPath)
        .writeAsBytes(await source.readAsBytes());
  }
}
