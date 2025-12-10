import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageOrientationFixer {
  /// Fixes image orientation based on EXIF data
  /// Returns the path to the corrected image file
  static Future<String> fixOrientation(XFile imageFile) async {
    try {
      // Read the image file
      final bytes = await imageFile.readAsBytes();
      
      // Decode the image
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        // If decoding fails, return original path
        return imageFile.path;
      }

      // The image package automatically handles EXIF orientation during decoding
      // Now encode it back without EXIF data
      final fixedBytes = img.encodeJpg(image, quality: 95);
      
      // Write to a new file
      final file = File(imageFile.path);
      await file.writeAsBytes(fixedBytes);
      
      return file.path;
    } catch (e) {
      // If any error occurs, return original path
      return imageFile.path;
    }
  }

  /// Fixes orientation and returns XFile
  static Future<XFile> fixOrientationAsXFile(XFile imageFile) async {
    final fixedPath = await fixOrientation(imageFile);
    return XFile(fixedPath);
  }
}
