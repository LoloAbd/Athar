import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'shared_text.dart';

class QuickActionCard extends StatelessWidget {
  final String image;
  final String title;
  final double imageWidth;
  final double imageHeight;
  final int fontSize;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.image,
    required this.title,
    this.imageWidth = 50,
    this.imageHeight = 50,
    this.fontSize = 14,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: imageWidth, height: imageHeight),

            const SizedBox(height: 5),

            SharedText(
              title: title,
              colorString: Colors.black,
              fontNum: fontSize,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
