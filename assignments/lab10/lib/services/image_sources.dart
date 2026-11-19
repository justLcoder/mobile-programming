import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// A download problem with a message that can be shown to the user as is.
class ImageDownloadException implements Exception {
  const ImageDownloadException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Camera, gallery and URL only differ in how the bytes arrive.
/// Every method returns raw image bytes; no file path leaves this class.
class ImageSources {
  final _picker = ImagePicker();

  static const downloadTimeout = Duration(seconds: 15);

  /// Null means the user cancelled.
  Future<Uint8List?> fromCamera() async {
    final shot = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
    );
    return shot == null ? null : await shot.readAsBytes();
  }

  /// Null means the user cancelled.
  Future<Uint8List?> fromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
    );
    return picked == null ? null : await picked.readAsBytes();
  }

  /// Downloads an image. Throws [ImageDownloadException] with a readable
  /// message for a bad address, a non-image response, no network or a timeout.
  Future<Uint8List> fromUrl(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      throw const ImageDownloadException(
        'That is not a valid web address. It must start with http:// or https://',
      );
    }

    final http.Response response;
    try {
      response = await http.get(uri).timeout(downloadTimeout);
    } on TimeoutException {
      throw ImageDownloadException(
        'The download took longer than ${downloadTimeout.inSeconds} seconds. '
        'Check your connection and try again.',
      );
    } on SocketException {
      throw const ImageDownloadException(
        'No network connection, or the server could not be found.',
      );
    } on http.ClientException catch (e) {
      throw ImageDownloadException('Could not reach the server: ${e.message}');
    }

    if (response.statusCode != 200) {
      throw ImageDownloadException(
        'The server answered with status ${response.statusCode} instead of 200. '
        'Check the address.',
      );
    }
    final type = response.headers['content-type'] ?? '';
    if (!type.startsWith('image/')) {
      throw ImageDownloadException(
        'That address is not a picture (it returned '
        '"${type.isEmpty ? 'no content type' : type.split(';').first}"). '
        'Use a direct link to an image file.',
      );
    }
    return response.bodyBytes;
  }
}
