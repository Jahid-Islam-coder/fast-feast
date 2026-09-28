import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// custom text widget to keep default properties clean
class ReusableText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool? softWrap;

  const ReusableText({
    super.key,
    required this.text,
    required this.style,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: softWrap ?? false,
      textAlign: textAlign ?? TextAlign.left,
      overflow: overflow,
      maxLines: maxLines,
      style: style,
    );
  }
}
