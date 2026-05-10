import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class ImageStorageService {
  Future<String> saveImage(String sourcePath);

  Future<void> deleteImage(String imagePath);
}

class ImageStorageServiceImpl implements ImageStorageService {
  @override
  Future<String> saveImage(String sourcePath) async {
    final sourceFile = File(sourcePath);
    final sourceExists = await sourceFile.exists();

    if (!sourceExists) {
      throw Exception('Source image not found at: $sourcePath');
    }

    final appDir = await getApplicationDocumentsDirectory();

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${basename(sourcePath)}';
    final destPath = '${appDir.path}/$fileName';

    final savedImage = await sourceFile.copy(destPath);

    return savedImage.path;
  }

  @override
  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
