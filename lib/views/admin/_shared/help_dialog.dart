import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  final List<HelpRow> helpRows;
  final String subject;

  const HelpDialog(this.subject, this.helpRows, {super.key});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final helpRow in helpRows) {
      children.add(const Divider());
      children.add(helpRow);
    }

    return AlertDialog(
        title: Text("Help with $subject"),
        content: SingleChildScrollView(
          child: Column(
            children: children,
          ),
        ));
  }
}

class HelpRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const HelpRow(this.text, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(color: Colors.black54, icon),
      const Spacer(),
      Text(text)
    ]);
  }
}
