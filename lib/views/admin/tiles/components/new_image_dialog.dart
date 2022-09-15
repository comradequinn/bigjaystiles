import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qinject/qinject.dart';

enum ImageSourceType { gallery, camera }

class NewImageDialog extends StatefulWidget {
  final File? _initialImage;
  final Qinjector _qinjector;

  const NewImageDialog(this._qinjector, this._initialImage, {super.key});

  @override
  State<NewImageDialog> createState() => _NewImageDialogState();
}

class _NewImageDialogState extends State<NewImageDialog> {
  File? _image;
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = widget._qinjector.use<NewImageDialog, ImagePicker>();
    _image = widget._initialImage;
  }

  @override
  Widget build(BuildContext context) {
    pickImage(ImageSource imageSource) async {
      XFile? image = await imagePicker.pickImage(
          source: imageSource,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front);
      setState(() {
        if (image != null) _image = File(image.path);
      });
    }

    return AlertDialog(
      title: const Text("Select Image"),
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            width: 200,
            height: 200,
            child: _image != null
                ? Image.file(
                    _image!,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  )
                : Container(
                    decoration: const BoxDecoration(color: Colors.grey),
                    width: 200,
                    height: 200,
                    child: const Icon(
                      Icons.camera_alt,
                    ),
                  ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
              icon: const Icon(Icons.browse_gallery_outlined),
              onPressed: () async {
                await pickImage(ImageSource.gallery);
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () async {
                await pickImage(ImageSource.camera);
              },
            )
          ])
        ],
      )),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(widget._initialImage),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () =>
                Navigator.of(context).pop(_image ?? widget._initialImage),
            child: const Text('OK'))
      ],
    );
  }
}
