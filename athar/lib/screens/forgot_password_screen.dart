import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const ForgotPassword({super.key, required this.onLanguageChanged});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND RESET EMAIL
  // ============================================================

  Future<void> _sendResetEmail() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showSuccessMessage();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showErrorMessage(e);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showGeneralError();
    }
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  void _showSuccessMessage() {
    final t = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.passwordResetEmailSent, textAlign: TextAlign.center),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // ============================================================
  // FIREBASE ERROR
  // ============================================================

  void _showErrorMessage(FirebaseAuthException e) {
    final t = AppLocalizations.of(context)!;

    String message;

    switch (e.code) {
      case 'invalid-email':
        message = t.invalidEmail;
        break;

      case 'user-not-found':
        message = t.userNotFound;
        break;

      case 'too-many-requests':
        message = t.tooManyRequests;
        break;

      case 'network-request-failed':
        message = t.networkError;
        break;

      case 'operation-not-allowed':
        message = t.emailPasswordNotEnabled;
        break;

      default:
        message = t.passwordResetError;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: const Color.fromARGB(255, 111, 9, 2),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // ============================================================
  // GENERAL ERROR
  // ============================================================

  void _showGeneralError() {
    final t = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.passwordResetError, textAlign: TextAlign.center),
        backgroundColor: const Color.fromARGB(255, 111, 9, 2),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  String? _validateEmail(String? value) {
    final t = AppLocalizations.of(context)!;

    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return t.enterEmail;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      return t.invalidEmail;
    }

    return null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,

              padding: const EdgeInsets.fromLTRB(10, 10, 30, 25),

              decoration: BoxDecoration(
                color: AppColors.primaryColorTrans,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    // ==================================================
                    // LANGUAGE BUTTON
                    // ==================================================
                    Align(
                      alignment: AlignmentDirectional.topStart,

                      child: IconButton(
                        onPressed: () {
                          final currentLanguage = Localizations.localeOf(
                            context,
                          ).languageCode;

                          if (currentLanguage == 'en') {
                            widget.onLanguageChanged(const Locale('ar'));
                          } else {
                            widget.onLanguageChanged(const Locale('en'));
                          }
                        },

                        icon: ImageIcon(
                          const AssetImage('assets/images/translation.png'),
                          size: 30,
                          color: AppColors.gold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // ==================================================
                    // TITLE
                    // ==================================================
                    buildText(
                      title: t.forgotPassword,
                      colorString: AppColors.darkBlue,
                      fontNum: 40,
                      fontWeight: FontWeight.bold,
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // MESSAGE
                    // ==================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      child: buildText(
                        title: t.forgotPasswordMessage,
                        colorString: AppColors.darkBlue,
                        fontNum: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==================================================
                    // EMAIL FIELD
                    // ==================================================
                    Align(
                      alignment: AlignmentDirectional.centerStart,

                      child: buildText(
                        title: t.email,
                        colorString: AppColors.darkBlue,
                        fontNum: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: emailController,

                      keyboardType: TextInputType.emailAddress,

                      textInputAction: TextInputAction.done,

                      autofillHints: const [AutofillHints.email],

                      validator: _validateEmail,

                      onFieldSubmitted: (_) {
                        if (!_isLoading) {
                          _sendResetEmail();
                        }
                      },

                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 16,
                      ),

                      decoration: InputDecoration(
                        hintText: t.enterYourEmail,

                        hintStyle: TextStyle(
                          color: AppColors.darkBlue.withValues(alpha: 0.55),
                        ),

                        filled: true,

                        fillColor: AppColors.primaryColor,

                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.darkBlue,
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 16,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(
                            color: AppColors.gold,
                            width: 2,
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(
                            color: AppColors.gold,
                            width: 2,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide(
                            color: AppColors.gold,
                            width: 2.5,
                          ),
                        ),

                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // SEND BUTTON
                    // ==================================================
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _sendResetEmail,

                      style: ElevatedButton.styleFrom(
                        elevation: 7,

                        minimumSize: const Size(200, 50),

                        backgroundColor: Colors.white,

                        disabledBackgroundColor: Colors.grey.shade300,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),

                        shadowColor: AppColors.gold,
                      ),

                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.darkBlue,
                              ),
                            )
                          : const Icon(
                              Icons.email_outlined,
                              size: 22,
                              color: Colors.black,
                            ),

                      label: buildText(
                        title: _isLoading ? t.sending : t.sendResetLink,

                        colorString: Colors.black,

                        fontNum: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // BACK TO LOGIN
                    // ==================================================
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },

                      child: buildText(
                        title: t.backToLogin,

                        colorString: AppColors.darkBlue,

                        fontNum: 16,

                        fontWeight: FontWeight.bold,

                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TEXT BUILDER
  // ============================================================

  Text buildText({
    required String title,
    required Color colorString,
    required int fontNum,
    FontWeight fontWeight = FontWeight.normal,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return Text(
      title,

      style: GoogleFonts.getFont(
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'Almarai'
            : 'Alike',

        textStyle: TextStyle(
          color: colorString,
          fontSize: fontNum.toDouble(),
          overflow: TextOverflow.ellipsis,
          fontWeight: fontWeight,
          decoration: decoration,
          decorationColor: AppColors.gold,
        ),
      ),

      maxLines: 10,

      textAlign: TextAlign.center,
    );
  }
}
