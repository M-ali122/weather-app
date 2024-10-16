import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/const/color.dart';
import 'package:weather_app/const/images.dart';
import 'package:weather_app/const/string.dart';
import 'package:weather_app/controller/main_controller.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.dart';
import 'package:weather_app/my_chatbot/chat.dart';
import 'package:weather_app/res/icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var controller = Get.put(MainController());

    var date = DateFormat('yMMMd').format(DateTime.now());

    var link =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    Future<CurrentWeatherData?> getCurrentWeather() async {
      var res = await http.get(Uri.parse(link));
      if (res.statusCode == 200) {
        var data = currentWeatherDataFromJson(res.body.toString());
        return data;
      } else {
        throw Exception('Failed to load current weather');
      }
    }

    var hourlylink =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    Future<HourlyWeatherData?> getHourlyWeather() async {
      var res = await http.get(Uri.parse(hourlylink));

      if (res.statusCode == 200) {
        var data = hourlyWeatherDataFromJson(res.body.toString());
        return data;
      } else {
        throw Exception('Failed to load hourly weather');
      }
    }

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // make Scaffold background transparent
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () {
                controller.changeTheme();
              },
              child: SvgPicture.string(
                  controller.isDark.value ? AppIcon.light : AppIcon.moon,
                  height: 40.h,
                  width: 40.w,
                  color: theme.primaryColor),
            ),
          ),
          10.widthBox,
          SvgPicture.string(
            AppIcon.more_vert,
            height: 30.h,
            color: theme.primaryColor,
          ),
          10.widthBox,
        ],
        title: date.text.color(theme.primaryColor).make(),
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var dat = snapshot.data;
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                20.heightBox,
                Container(
                  height: 200.h,
                  padding: EdgeInsets.only(top: 20.h),
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            offset: Offset(0, 2),
                            color: cardColor)
                      ]),
                  child: ListTile(
                    title: '${dat?.name.toString().toUpperCase()}'
                        .text
                        .color(theme.primaryColor)
                        .fontFamily('poppins_bold')
                        .size(32.sp)
                        .letterSpacing(2)
                        .make(),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/weather/${dat!.weather[0].icon}.png',
                          width: 110.w,
                          height: 110.h,
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text:
                                    '${dat.main.temp.toStringAsFixed(0)}$degree',
                                style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: 64.sp,
                                    fontFamily: 'poppins')),
                            TextSpan(
                                text: dat.weather[0].main,
                                style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: 14.sp,
                                    letterSpacing: 2,
                                    fontFamily: 'poppins_light'))
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: SvgPicture.string(
                        AppIcon.arrow_up,
                        height: 20.h,
                        width: 20.w,
                        color: theme.iconTheme.color,
                      ),
                      label: '${dat.main.tempMax.toStringAsFixed(0)}$degree'
                          .text
                          .color(theme.iconTheme.color)
                          .make(),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: SvgPicture.string(
                        AppIcon.arrow_down,
                        height: 20.h,
                        width: 20.w,
                        color: theme.iconTheme.color,
                      ),
                      label: '${dat.main.tempMin.toStringAsFixed(0)}$degree'
                          .text
                          .color(theme.iconTheme.color)
                          .make(),
                    ),
                  ],
                ),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (index) {
                      var values = [
                        '${dat.clouds.all}%',
                        '${dat.main.humidity}%',
                        '${dat.wind.speed} km/h'
                      ];
                      var iconList = [cloud, humidity, windspeed];
                      return Column(
                        children: [
                          Image.asset(
                            iconList[index],
                            width: 60.w,
                            height: 60.h,
                          )
                              .box
                              .gray200
                              .padding(const EdgeInsets.all(8))
                              .roundedSM
                              .make(),
                          10.heightBox,
                          values[index].text.gray400.make(),
                        ],
                      );
                    },
                  ),
                ),
                10.heightBox,
                const Divider(),
                SizedBox(
                  height: 160.h,
                  child: FutureBuilder(
                    future: getHourlyWeather(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var hourlyData = snapshot.data;
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            var hour = DateTime.now().hour + index + 1;
                            var time =
                                hour > 12 ? '${hour - 12} PM' : '$hour AM';
                            var weatherIcon =
                                hourlyData!.list[index].weather[0].icon;
                            var temp = hourlyData.list[index].main.temp
                                .toStringAsFixed(0);
                            return Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  time.text.gray200.make(),
                                  Image.asset(
                                    'assets/weather/$weatherIcon.png',
                                    width: 70.w,
                                  ),
                                  5.heightBox,
                                  '$temp$degree'.text.white.make(),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                10.heightBox,
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    'Next 7 days'
                        .text
                        .color(theme.primaryColor)
                        .semiBold
                        .size(16.sp)
                        .make(),
                    TextButton(
                      onPressed: () {},
                      child: 'View All'.text.make(),
                    ),
                  ],
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    var day = DateFormat('EEEE')
                        .format(DateTime.now().add(Duration(days: index + 1)));
                    return Card(
                      color: theme.cardColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: day.text
                                  .color(theme.primaryColor)
                                  .semiBold
                                  .make(),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/weather/50n.png',
                                  width: 50.w,
                                  height: 50.h,
                                ),
                                label: '26$degree'
                                    .text
                                    .color(theme.primaryColor)
                                    .make(),
                              ),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '35$degree /',
                                  style: TextStyle(
                                    color: Vx.gray700,
                                    fontFamily: 'poppins',
                                    fontSize: 16.sp,
                                  ),
                                ),
                                TextSpan(
                                  text: ' 26$degree',
                                  style: TextStyle(
                                    color: Vx.gray500,
                                    fontFamily: 'poppins',
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ChatBot());
        },
        shape: CircleBorder(),
        child: SvgPicture.string(AppIcon.ai),
      ),
    );
  }
}
