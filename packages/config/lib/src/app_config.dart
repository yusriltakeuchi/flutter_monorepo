import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_ui/theme/my_theme.dart';

class Space {
  static SizedBox w(double width) {
    return SizedBox(width: AppSetting.setWidth(width));
  }

  static SizedBox h(double height) {
    return SizedBox(height: AppSetting.setHeight(height));
  }
}

class AppSetting {
  /// Device Size
  /// ------------
  static double get deviceWidth => ScreenUtil().screenWidth;
  static double get deviceHeight => ScreenUtil().screenHeight;

  static bool isLargePhone(BuildContext context) =>
      MediaQuery.of(context).size.width > 600 ? true : false;
  static bool isNormalPhone(BuildContext context) =>
      MediaQuery.of(context).size.width > 400 &&
          MediaQuery.of(context).size.width < 600
      ? true
      : false;
  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < 400 ? true : false;
  static bool isNormalToBig(BuildContext context) =>
      MediaQuery.of(context).size.height > 800 &&
          MediaQuery.of(context).size.height < 1200
      ? true
      : false;
  static bool isNormalPhoneHeight(BuildContext context) =>
      MediaQuery.of(context).size.height > 750 &&
          MediaQuery.of(context).size.height < 950
      ? true
      : false;
  static bool isSmallPhoneHeight(BuildContext context) =>
      MediaQuery.of(context).size.height < 750 ? true : false;
  static bool isReallySmallPhoneHeight(BuildContext context) =>
      MediaQuery.of(context).size.height < 600 ? true : false;
  static bool isBigPhoneHeight(BuildContext context) =>
      MediaQuery.of(context).size.height > 950 ? true : false;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600 &&
          MediaQuery.of(context).size.height > 700
      ? true
      : false;

  /// Setting height and width
  static double setWidth(double width) => ScreenUtil().setWidth(width);
  static double setHeight(double height) => ScreenUtil().setHeight(height);

  /// Setting fontsize
  static double setFontSize(double size) => size.sp;

  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: MyTheme.color.grey.withValues(alpha: 0.2),
      blurRadius: 10,
      spreadRadius: 3,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: MyTheme.color.grey.withValues(alpha: 0.1),
      blurRadius: 8,
      spreadRadius: 1,
      offset: const Offset(0, 5),
    ),
  ];
}
