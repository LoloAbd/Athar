import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SharedTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData iconReq;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool isSecure;

  const SharedTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.iconReq,
    this.validator,
    required this.controller,
    this.isSecure = false,
  });

  @override
  State<SharedTextFormField> createState() => _SharedTextFormFieldState();
}

class _SharedTextFormFieldState extends State<SharedTextFormField> {
  bool isPasswordVisible = false;

  // Colors
  static const Color gold = Color(0xFFE3B866);

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final fontFamily = isArabic ? 'Almarai' : 'Alike';

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isSecure && !isPasswordVisible,

      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,

        labelText: widget.labelText,

        labelStyle: GoogleFonts.getFont(
          fontFamily,
          textStyle: TextStyle(color: AppColors.darkBlue, fontSize: 15),
        ),

        hintText: widget.hintText,

        hintStyle: GoogleFonts.getFont(
          fontFamily,
          textStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        ),

        filled: true,
        fillColor: AppColors.secondaryColor,

        prefixIcon: Icon(widget.iconReq, color: AppColors.darkBlue),

        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isSecure)
              IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.darkBlue,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),

            IconButton(
              icon: Icon(Icons.clear, color: AppColors.darkBlue),
              onPressed: () {
                widget.controller.clear();
              },
            ),
          ],
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 2),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),

      validator: widget.validator,
    );
  }
}
