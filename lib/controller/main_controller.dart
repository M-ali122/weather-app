import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  @override
  void onInit() {
    // hourlyWeatherData = getHourlyWeather();
    super.onInit();
  }

  var hourlyWeatherData;
  RxBool isDark = true.obs;

  changeTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }
}
