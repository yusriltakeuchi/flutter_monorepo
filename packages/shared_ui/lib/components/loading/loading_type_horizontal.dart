import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_extension/shared_extension.dart';

class LoadingTypeHorizontal extends StatelessWidget {
  final int length;

  const LoadingTypeHorizontal({
    super.key,
    this.length = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            length,
            (i) => Container(
              width: AppSetting.setWidth(150),
              height: AppSetting.setHeight(40),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: context.greyDarkColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}