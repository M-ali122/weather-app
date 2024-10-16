import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/res/theme.dart';
import 'package:weather_app/splash/view/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "basic Channel Group",
        channelKey: "basic channel",
        channelName: "Basic Notification",
        channelDescription: "testNotification")
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "basic channel group",
        channelGroupName: "group channel")
  ]);

  bool isAllowToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('fcmToken is $fcmToken');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: CustomeTheme.lightTheme,
          darkTheme: CustomeTheme.DarkTheme,
          title: 'weather app',
          themeMode: ThemeMode.system,
          home: SplashScreen(),
        );
      },
    );
  }
}
