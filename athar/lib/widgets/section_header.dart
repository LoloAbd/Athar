import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'shared_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.auto_awesome,
          size: 20,
          color: AppColors.lightGold,
        ),
        Container(
          width: 10,
          height: 1.5,
          color: AppColors.lightGold,
        ),
        const SizedBox(width: 2),
        SharedText(
          title: title,
          colorString: Colors.black,
          fontNum: 16,
        ),
        const SizedBox(width: 2),
        Container(
          width: 10,
          height: 1.5,
          color: AppColors.lightGold,
        ),
        Icon(
          Icons.auto_awesome,
          size: 20,
          color: AppColors.lightGold,
        ),
      ],
    );
  }
}