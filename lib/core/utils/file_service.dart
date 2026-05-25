import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileService {
  static Future<String> saveImageToPermanentStorage(String tempPath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/images');
      
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = path.basename(tempPath);
      final permanentPath = '${imagesDir.path}/$fileName';
      
      final File tempFile = File(tempPath);
      await tempFile.copy(permanentPath);
      
      return permanentPath;
    } catch (e) {
      print('Error saving image: $e');
      return tempPath;
    }
  }
}
