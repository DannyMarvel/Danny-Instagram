import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
//Not anything on Dart.io is not avaliable on the web version

pickImage(ImageSource source) async {
//Now we intantiate the _imagePicker
  final ImagePicker _imagePicker = ImagePicker();
//Now we use _imagePicker of pick an image from a source

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
