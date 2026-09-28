import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SharedText extends StatelessWidget {
  final String title;
  final Color colorString;
  final int fontNum;
  final FontWeight fontWeight;
  final TextDecoration decoration;
  final TextAlign? textAlign;
  final List<Shadow>? shadow;
  final TextOverflow? textOverflow;
  final int? maxLines;

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
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final fontFamily = isArabic ? 'Almarai' : 'Alike';
    final effectiveColor = colorString == Colors.black
        ? AppColors.darkBlue
        : colorString;

    return Text(
      title,

      style: GoogleFonts.getFont(
        fontFamily,

        textStyle: TextStyle(
          color: effectiveColor,
          fontSize: fontNum.toDouble(),
          overflow: textOverflow,
          fontWeight: fontWeight,
          decoration: decoration,
          decorationColor: gold,
        ),
      ),

      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
