import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qinject/qinject.dart';

import '../../config/config.dart';
import '../../tiles/model.dart';
import 'components/category_navigation_bar.dart';
import 'components/hamburger_menu.dart';
import 'components/tile_list.dart';
import 'home_view.dart';

void main() {
  final qinjector = TestQinjector();

  qinjector.registerTestDouble<TileReader>((_) => TileReaderStub());
  qinjector.registerTestDouble<Config>((_) => ConfigStub());

  qinjector.registerTestDouble((_) => (
        Iterable<Category> c,
        Function(Category) oct,
      ) =>
          // ignore: unnecessary_cast
          const CategoryNavigationBarStub() as CategoryNavigationBar);

  qinjector.registerTestDouble<HamburgerMenu Function()>(
      (_) => () => const HamburgerMenuStub());

  qinjector.registerTestDouble<TileList Function(Category?)>(
      (_) => (Category? _) => const TileListStub());

  testWidgets('Home View renders correct app name',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HomeView(qinjector)));

    expect(find.text(qinjector.use<void, Config>().appname), findsOneWidget);
  });
}

class TileListStub extends StatefulWidget implements TileList {
  const TileListStub({Key? key}) : super(key: key);

  @override
  State<TileList> createState() => _TestStubState();
}

class HamburgerMenuStub extends StatelessWidget implements HamburgerMenu {
  const HamburgerMenuStub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Text("");
}

class CategoryNavigationBarStub extends StatefulWidget
    implements CategoryNavigationBar {
  const CategoryNavigationBarStub({Key? key}) : super(key: key);

  @override
  State<CategoryNavigationBar> createState() => _TestStubState();
}

class _TestStubState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) => const Text("");
}

class TileReaderStub implements TileReader {
  @override
  List<Category> categories({includeHidden = false}) => List<Category>.empty();

  @override
  ValueNotifier<bool> get changeNotifier => ValueNotifier(true);

  @override
  List<Tile> tiles(Category c) => List<Tile>.empty();
}

class ConfigStub implements Config {
  @override
  String get appname => "Test Appname";
}
