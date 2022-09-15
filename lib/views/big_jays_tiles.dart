import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';

import '../config/config.dart';
import 'admin/categories/manage_categories_view.dart';
import 'admin/tiles/manage_tiles_view.dart';
import 'home/home_view.dart';

class BigJaysTiles extends StatelessWidget {
  final HomeView Function() _homeView;
  final ManageCategoriesView Function() _manageCategoriesView;
  final ManageTilesView Function() _manageTilesView;
  final Config _config;

  BigJaysTiles(Qinjector qinjector, {Key? key})
      : _config = qinjector.use<BigJaysTiles, Config>(),
        _homeView = qinjector.use<BigJaysTiles, HomeView Function()>(),
        _manageCategoriesView =
            qinjector.use<BigJaysTiles, ManageCategoriesView Function()>(),
        _manageTilesView =
            qinjector.use<BigJaysTiles, ManageTilesView Function()>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black54,
                displayColor: Colors.black54,
              )),
      title: _config.appname,
      initialRoute: '/',
      routes: {
        '/': (_) => _homeView(),
        '/admin/categories/': (_) => _manageCategoriesView(),
        '/admin/tiles/': (_) => _manageTilesView(),
      },
    );
  }
}
