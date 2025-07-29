import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomHtml extends StatelessWidget {
  final String text;
  final Color? bodyColor;
  final Color? pColor;
  final Color? subColor;
  final Color? supColor;

  const CustomHtml({super.key, required this.text, this.bodyColor, this.pColor, this.subColor, this.supColor});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: text,
      style: {
        "body": Style(
          fontSize: FontSize(14),
          fontFamily: 'poppins',
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: bodyColor,
        ),
        "p": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: pColor,
        ),
        "sub": Style(
          fontSize: FontSize(10),
          verticalAlign: VerticalAlign.sub,
          color: subColor,
        ),
        "sup": Style(
          fontSize: FontSize(10),
          verticalAlign: VerticalAlign.sup,
          color: supColor,
        ),
      },
    );
  }
}