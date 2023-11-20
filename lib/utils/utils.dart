// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagraam/responsive/mobile_screen_layout.dart';
import 'package:instagraam/responsive/responsive_layout.dart';
import 'package:instagraam/responsive/web_screen_layout.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

goResonsive() {
  Get.to(const ResponsiveLayout(
      webScreenLayout: WebScreenLayout(),
      mobileScreenLayout: MobileScreenLayout()));
}

offResonsive() {
  Get.off(const ResponsiveLayout(
      webScreenLayout: WebScreenLayout(),
      mobileScreenLayout: MobileScreenLayout()));
}

offAllResponsive() {
  Get.offAll(const ResponsiveLayout(
      webScreenLayout: WebScreenLayout(),
      mobileScreenLayout: MobileScreenLayout()));
}
