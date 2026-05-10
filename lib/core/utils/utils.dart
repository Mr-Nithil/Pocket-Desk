import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.pickFiles(type: FileType.image);

    if (filePickerRes != null) {
      return File(filePickerRes.files.first.path!);
    }

    return null;
  } catch (e) {
    return null;
  }
}
