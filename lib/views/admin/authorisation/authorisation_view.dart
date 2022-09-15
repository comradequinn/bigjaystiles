import 'dart:math';

import 'package:flutter/material.dart';

class AuthorisationView extends StatefulWidget {
  static final _random = Random();

  const AuthorisationView({Key? key}) : super(key: key);

  @override
  State<AuthorisationView> createState() => _AuthorisationViewState();
}

class _AuthorisationViewState extends State<AuthorisationView> {
  var _input = -1;
  final _num1 = AuthorisationView._random.nextInt(9) + 1;
  final _num2 = AuthorisationView._random.nextInt(9) + 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Restricted Page"),
      content: SingleChildScrollView(
          child: Column(children: [
        Text("To access this area, enter the answer to $_num1 + $_num2:  "),
        const SizedBox(height: 20),
        SizedBox(
            width: 50,
            height: 30,
            child: TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                setState(() {
                  _input = int.tryParse(text) ?? -1;
                });
              },
            ))
      ])),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(_input == _num1 + _num2);
            },
            child: const Text('Unlock'))
      ],
    );
  }
}
