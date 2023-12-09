import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

double getWidth() {
  return MediaQuery.sizeOf(Get.context!).width;
}

double getHeight() {
  return MediaQuery.sizeOf(Get.context!).height;
}

String getDeviceType() {
  final size = MediaQuery.sizeOf(Get.context!);

  return (MediaQuery.orientationOf(Get.context!) != Orientation.landscape ||
          size.width < 610)
      ? 'phone'
      : 'tablet';
}

Future<Uint8List?> loadImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;

    final image = img.decodeImage(bytes);

    final pngBytes = img.encodePng(image!);

    return Uint8List.fromList(pngBytes);
  } else {
    return null;
  }
}
