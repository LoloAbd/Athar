import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharedText extends StatelessWidget {
  final String title;
  final Color colorString;
  final int fontNum;
  final FontWeight fontWeight;
  final TextDecoration decoration;
  final TextAlign? textAlign;
  final List<Shadow>? shadow;
  final TextOverflow? textOverflow;

  static const Color gold = Color(0xFFE3B866);

  const SharedText({
    super.key,
    required this.title,
    required this.colorString,
    required this.fontNum,
    this.fontWeight = FontWeight.normal,
    this.decoration = TextDecoration.none,
    this.textAlign,
    this.shadow,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final fontFamily = isArabic ? 'Almarai' : 'Alike';

    return Text(
      title,

      style: GoogleFonts.getFont(
        fontFamily,

        textStyle: TextStyle(
          color: colorString,
          fontSize: fontNum.toDouble(),
          overflow: TextOverflow.ellipsis,
          fontWeight: fontWeight,
          decoration: decoration,
          decorationColor: gold,
        ),
      ),

      maxLines: 10,
      textAlign: textAlign,
    );
  }
}
