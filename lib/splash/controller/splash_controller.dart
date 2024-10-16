import 'package:get/get.dart';
import 'package:weather_app/home_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    splashService();
  }

  void splashService() async {
    await Future.delayed(const Duration(seconds: 10));

    Get.to(() => HomeScreen());
  }
}
