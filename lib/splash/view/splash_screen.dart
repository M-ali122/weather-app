import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // Simulate some initialization process
    Future.delayed(Duration(seconds: 3), () {
      Get.to(() => HomeScreen()); // Navigate to '/home' route using GetX
    });

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/svgviewer-output.png'),
            'Weather'
                .text
                .color(theme.primaryColor)
                .size(23.sp)
                .fontWeight(FontWeight.w600)
                .make(),
            // 5.heightBox,
            'Fore Casts'
                .text
                .color(theme.primaryColor)
                .size(23.sp)
                .fontWeight(FontWeight.w400)
                .make(),
          ],
        ));
  }
}
