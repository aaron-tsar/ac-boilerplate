import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CameraService {
  static ImagePicker picker = ImagePicker();

  static Future<File?> captureFromCamera() async {
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      if(photo != null) {
        return File(photo.path);
      }
      return null;
    }  catch(_) {

      rethrow;
    }
  }

  static Future<File?> recordFromCamera() async {
    try {
      final XFile? photo = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );
      if(photo != null) {
        return File(photo.path);
      }
      return null;
    } catch(e) {
      rethrow;
    }
  }

  static Future<File?> pickFromGallery() async {
    try {
      final XFile? photo = await picker.pickImage(
        maxHeight: 1000,
        maxWidth: 1000,
        source: ImageSource.gallery,
      );
      if(photo != null) {
        return File(photo.path);
      }
      return null;
    } catch(e) {
      rethrow;
    }
  }
}
