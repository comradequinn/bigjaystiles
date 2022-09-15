import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../../config/config.dart';
import '../../tiles/model.dart';
import 'components/category_navigation_bar.dart';
import 'components/hamburger_menu.dart';
import 'components/tile_list.dart';

class HomeView extends StatefulWidget {
  final TileReader _tileReader;
  final Config _config;
  final CategoryNavigationBar Function(Iterable<Category>, Function(Category))
      _categoryNavigationBar;
  final HamburgerMenu Function() _hamburgerMenu;
  final TileList Function(Category?) _tileList;

  HomeView(Qinjector qinjector, {Key? key})
      : _tileReader = qinjector.use<HomeView, TileReader>(),
        _config = qinjector.use<HomeView, Config>(),
        _categoryNavigationBar = qinjector.use<
            HomeView,
            CategoryNavigationBar Function(
                Iterable<Category>, Function(Category))>(),
        _hamburgerMenu = qinjector.use<HomeView, HamburgerMenu Function()>(),
        _tileList = qinjector.use<HomeView, TileList Function(Category?)>(),
        super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    var tc = widget._tileReader;

    return ValueListenableBuilder(
        valueListenable: tc.changeNotifier,
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget._config.appname),
            ),
            drawer: widget._hamburgerMenu(),
            body: widget._tileList(_selectedCategory),
            bottomNavigationBar: widget._categoryNavigationBar(tc.categories(),
                (Category c) => setState(() => _selectedCategory = c)),
          );
        });
  }
}
