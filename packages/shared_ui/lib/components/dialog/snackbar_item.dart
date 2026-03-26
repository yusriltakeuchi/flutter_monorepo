import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/theme/my_theme.dart';

showSnackbar({
  required BuildContext context,
  required String? title,
  Color? color,
  Color? textColor,
}) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          title!,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style:  MyTheme.style.title.copyWith(
            fontSize: AppSetting.setFontSize(40),
            color: textColor ?? Colors.white,
          ),
        ),
        backgroundColor: color,
      ),
    );