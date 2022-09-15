import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Big Jay's Tiles"),
      content: SingleChildScrollView(
          child: RichText(
              text: const TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  children: [
            TextSpan(
                text:
                    '''This app was originally for, and is dedicated to, our wonderful son, Jacob. Or 'Big Jay', who is severely autistic and entirely non-verbal.
                            
We share it in the hope that other parents and carers with children or loved ones like Jacob may find it helpful. 
                            
If you have any questions, contact us on '''),
            TextSpan(
                text: 'comradequinn@gmail.com',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            TextSpan(
              text: ''' and we'll try our best to help.

If you like the app and would like to buy `Big Jay` a little cake and a coffee (OK, the coffee's for 
us - Jacob's hyper enough without the caffeine) to help us maintain it, you can PayPal us on the same email!

Thanks,

Big Jay & his Mummy & Daddy 
''',
            )
          ]))),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'))
      ],
    );
  }
}
