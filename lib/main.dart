import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bigjaystiles/views/admin/categories/components/icon_picker/icon_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qinject/qinject.dart';
import 'package:record/record.dart';

import 'config/config.dart';
import 'tiles/db/tile_db_initialiser.dart';
import 'tiles/model.dart';
import 'tiles/tile_controller.dart';
import 'tiles/db/tile_db.dart';
import 'views/admin/_shared/help_dialog.dart';
import 'views/admin/categories/components/delete_category_dialog.dart';
import 'views/admin/categories/components/manage_categories_help_dialog.dart';
import 'views/admin/categories/manage_categories_view.dart';
import 'views/admin/categories/components/add_category_dialog.dart';
import 'views/admin/categories/components/category_list.dart';
import 'views/admin/categories/components/category_list_item.dart';
import 'views/admin/tiles/components/add_tile_dialog.dart';
import 'views/admin/tiles/components/delete_tile_dialog.dart';
import 'views/admin/tiles/components/manage_tiles_help_dialog.dart';
import 'views/admin/tiles/components/new_audio_dialog.dart';
import 'views/admin/tiles/components/new_image_dialog.dart';
import 'views/admin/tiles/components/tile_list.dart' as admin;
import 'views/admin/tiles/components/tile_list_item.dart' as admin;
import 'views/admin/tiles/manage_tiles_view.dart';
import 'views/big_jays_tiles.dart';
import 'views/home/components/category_navigation_bar.dart';
import 'views/home/components/hamburger_menu.dart';
import 'views/home/components/tile_list.dart' as home;
import 'views/home/components/tile_list_item.dart' as home;
import 'views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataDirectory = (await getApplicationDocumentsDirectory()).path;
  final tileDB = await TileDB.open(TileDBInitialiser(), dataDirectory);
  final qinjector = Qinject.instance();

  Qinject.log = (message) => debugPrint(message);

  Qinject.registerSingleton(() => AudioPlayer());
  Qinject.register((_) => Record());
  Qinject.registerSingleton((() => Config()));
  Qinject.registerSingleton((() => tileDB));
  Qinject.registerSingleton((() => TileController(qinjector)));
  Qinject.registerSingleton<TileReader>(
      (() => Qinject.use<void, TileController>()));

  Qinject.register((_) => () => HomeView(qinjector));
  Qinject.register((_) => () => const HamburgerMenu());
  Qinject.register((_) => (Category? c) => home.TileList(qinjector, c));
  Qinject.register((_) => MediaQuery.of);
  Qinject.register((_) => (Tile t, Category c, double w, double h) =>
      home.TileListItem(t, c, w, h));

  Qinject.register((_) => (String s, List<HelpRow> hr) => HelpDialog(s, hr));

  Qinject.register((_) => () => ManageTilesView(qinjector));
  Qinject.register((_) => () => admin.TileList(qinjector));
  Qinject.register(
      (_) => (Tile t, Category c) => admin.TileListItem(qinjector, t, c));
  Qinject.register((_) => () => AddTileDialog(qinjector));
  Qinject.register((_) => (Tile t) => DeleteTileDialog(t));
  Qinject.register((_) => (File? f) => NewImageDialog(qinjector, f));
  Qinject.register((_) => (File? f) => NewAudioDialog(qinjector, f));
  Qinject.register((_) => () => ManageTilesHelpDialog(qinjector));
  Qinject.register((_) => ImagePicker());

  Qinject.register((_) => () => ManageCategoriesView(qinjector));
  Qinject.register((_) => () => CategoryList(qinjector));
  Qinject.register((_) => (Category c) => CategoryListItem(qinjector, c));
  Qinject.register((_) => () => AddCategoryDialog(qinjector));
  Qinject.register((_) => (Category c) => DeleteCategoryDialog(c));
  Qinject.register((_) => () => ManageCategoriesHelpDialog(qinjector));
  Qinject.register((_) => () => IconPicker());

  Qinject.register((_) => (
        Iterable<Category> c,
        Function(Category) oct,
      ) =>
          CategoryNavigationBar(c, oct));

  runApp(BigJaysTiles(qinjector));
}
