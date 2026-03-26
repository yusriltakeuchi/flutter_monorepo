import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/theme/my_theme.dart';

class Required extends StatelessWidget {
  final Widget child;
  const Required({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        child,
        Space.w(10),
        Text(
          "*",
          style: MyTheme.style.subtitle.copyWith(
            fontSize: AppSetting.setFontSize(40),
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}