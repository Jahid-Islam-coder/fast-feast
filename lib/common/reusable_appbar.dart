import 'package:flutter/material.dart';
import 'app_style.dart';
import 'reusable_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// simple custom appbar wrapper
class CustomReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? elevation;

  const CustomReusableAppBar({
    super.key,
    this.titleText,
    this.titleStyle,
    this.titleWidget,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.bottom,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? const Color(0xFFECE3F7),
      elevation: elevation ?? 0,
      leading: leading,
      title: titleWidget ?? (titleText != null ? ReusableText(
        text: titleText!,
        style: titleStyle ?? appStyle(20.sp, Colors.black, FontWeight.bold),
      ) : null),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        bottom != null ? kToolbarHeight + bottom!.preferredSize.height : kToolbarHeight,
      );
}
