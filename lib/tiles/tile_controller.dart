import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:qinject/qinject.dart';

import 'db/tile_db.dart';
import 'model.dart';

class TileController implements TileReader {
  @override
  final ValueNotifier<bool> changeNotifier = ValueNotifier(false);

  final TileDB _tileDB;
  List<Category>? _categories;
  List<Tile>? _tiles;

  TileController(Qinjector qinjector)
      : _tileDB = qinjector.use<TileController, TileDB>();

  @override
  List<Category> categories({includeHidden = false}) {
    final categories = _categories ?? _tileDB.categories();

    _categories = categories;

    return includeHidden
        ? categories
        : categories.where((c) => !c.hidden).toList();
  }

  Future<Category> addCategory(String title, IconData icon, bool hidden) async {
    final t = _tileDB.addCategory(title, icon, hidden);

    handleDataChanged();

    return t;
  }

  Future<void> updateCategory(Category c) async {
    await _tileDB.updateCategory(c);

    handleDataChanged();
  }

  Future<void> swapCategories(Category categoryA, Category categoryB) async {
    await _tileDB.swapCategories(categoryA, categoryB);

    handleDataChanged();
  }

  Future<void> deleteCategory(Category c) async {
    await _tileDB.deleteCategory(c);

    handleDataChanged();
  }

  @override
  List<Tile> tiles(Category c) {
    final tiles = _tiles ?? _tileDB.tiles();

    _tiles = tiles;

    return tiles.where((t) => t.categoryID == c.id).toList();
  }

  Future<Tile> addTile(
      String title, File image, File audio, int categoryID) async {
    final t = await _tileDB.addTile(title, image, audio, categoryID);
    handleDataChanged();
    return t;
  }

  Future<void> updateTile(Tile t) async {
    await _tileDB.updateTile(t);
    handleDataChanged();
  }

  Future<void> swapTiles(Tile tileA, Tile tileB) async {
    await _tileDB.swapTiles(tileA, tileB);
    handleDataChanged();
  }

  Future<void> deleteTile(Tile t) async {
    await _tileDB.deleteTile(t);
    handleDataChanged();
  }

  Future<File> writeImage(File source) async {
    return _tileDB.writeImage(source);
  }

  Future<File> writeAudio(File source) async {
    return _tileDB.writeAudio(source);
  }

  void handleDataChanged() {
    _categories = null;
    _tiles = null;
    changeNotifier.value = !changeNotifier.value;
  }
}
