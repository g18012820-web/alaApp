import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageCacheHelper {
  static final ImageCacheHelper _instance = ImageCacheHelper._internal();

  final Map<String, ui.Image?> _imageCache = {};

  factory ImageCacheHelper() {
    return _instance;
  }

  ImageCacheHelper._internal();

  Future<ui.Image?> loadImage(String assetPath) async {
    if (_imageCache.containsKey(assetPath)) {
      return _imageCache[assetPath];
    }

    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(Uint8List.fromList(bytes));

    _imageCache[assetPath] = image;

    return image;
  }
}
