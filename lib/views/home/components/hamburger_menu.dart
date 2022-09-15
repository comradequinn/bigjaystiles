import 'package:flutter/material.dart';

import '../../admin/about/about_view.dart';
import '../../admin/authorisation/authorisation_view.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  _navigateOnAuth(BuildContext context, String route) async {
    if (await showDialog<bool>(
            context: context,
            builder: (context) => const AuthorisationView()) ==
        true) {
      Navigator.of(context).pushNamed(route);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Icon(Icons.settings, size: 96.0),
          ),
          ListTile(
              title: const Text('Manage Tiles'),
              onTap: () async {
                _navigateOnAuth(context, "/admin/tiles/");
              }),
          ListTile(
            title: const Text('Manage Categories'),
            onTap: () async {
              _navigateOnAuth(context, "/admin/categories/");
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Back-up or Restore Data'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Back-up or Restore Data'),
                        content: const SingleChildScrollView(
                            child: Text(
                                "This feature is not currently available")),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'))
                        ],
                      ));
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            onTap: () {
              showDialog(
                  context: context, builder: (context) => const AboutView());
            },
          ),
        ],
      ),
    );
  }
}
