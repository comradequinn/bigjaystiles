import 'package:flutter/material.dart';

import '../../../tiles/model.dart';

class CategoryNavigationBar extends StatefulWidget {
  final Function(Category) _onCategoryTap;
  final Iterable<Category> _categories;

  const CategoryNavigationBar(this._categories, this._onCategoryTap, {Key? key})
      : super(key: key);

  @override
  State<CategoryNavigationBar> createState() => _CategoryNavigationBarState();
}

class _CategoryNavigationBarState extends State<CategoryNavigationBar> {
  int _selectedIndex = 0;
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    var categories = widget._categories;

    if (categories.length < 2) {
      return Row(children: const [SizedBox(height: 20)]);
    }

    // if the current category has been deleted by the user, default it to the first category
    if (!categories.contains(_selectedCategory)) {
      _selectedIndex = 0;
      _selectedCategory = categories.elementAt(0);
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: () {
        List<BottomNavigationBarItem> items = [];

        for (var category in categories) {
          items.add(BottomNavigationBarItem(
            icon: Icon(category.icon),
            label: category.title,
          ));
        }

        return items;
      }(),
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: (int index) {
        _selectedIndex = index;
        _selectedCategory = categories.elementAt(index);
        widget._onCategoryTap(categories.elementAt(index));
      },
    );
  }
}
