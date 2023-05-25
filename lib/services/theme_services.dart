import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeServices extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  bool get isDarkMode => _loadThemeFromBox();

  @override
  void onInit() {
    super.onInit();
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void switchTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!isDarkMode);
  }

  bool _loadThemeFromBox() {
    return _box.read(_key) ?? false;
  }

  void _saveThemeToBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }
}
