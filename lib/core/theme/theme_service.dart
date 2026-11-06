import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find<ThemeService>();

  late final GetStorage _box;
  static const String _key = 'is_dark_mode';

  final RxBool isDarkMode = false.obs;

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<ThemeService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    final savedMode = _box.read<bool>(_key);
    if (savedMode != null) {
      isDarkMode.value = savedMode;
    } else {
      // Default to light mode matching reference screenshots 2 & 3
      isDarkMode.value = false;
    }
    return this;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _box.write(_key, isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }

  void setTheme(bool dark) {
    if (isDarkMode.value == dark) return;
    isDarkMode.value = dark;
    _box.write(_key, isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }
}
