import 'package:flutter/material.dart';

import 'icon_db.dart';

class IconPicker extends StatefulWidget {
  final IconDB _iconDB = IconDB();

  IconPicker({Key? key}) : super(key: key);

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  var searchTerm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, IconData> iconList = widget._iconDB.search(searchTerm.text);

    return AlertDialog(
      title: const Text("Choose Icon"),
      content: SizedBox(
          width: (MediaQuery.of(context).size.width) * .6,
          height: (MediaQuery.of(context).size.height) * .6,
          child: Column(
            children: [
              TextField(
                controller: searchTerm,
                autofocus: true,
                decoration: const InputDecoration(
                  counterText: "",
                  hintText: "Search....",
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: iconList.length,
                      itemBuilder: (context, index) {
                        var key = iconList.keys.elementAt(index);

                        return GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pop(iconList[key]),
                            child: ListTile(
                                leading: Icon(iconList[key]),
                                title: Text(key.replaceAll("_", " "))));
                      }))
            ],
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancel"))
      ],
    );
  }
}
