import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/shared_snack_bar.dart';
import '../widgets/shared_text.dart';
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

  Future<void> _sendResetEmail(AppLocalizations t) async {
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

      SharedSnackBar.showSuccess(
        context: context,
        message: t.passwordResetEmailSent,
      );
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

      SharedSnackBar.showError(context: context, message: t.passwordResetError);
    }
  }


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

    SharedSnackBar.showError(context: context, message: message);
  }


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
                    SharedText(
                      title: t.forgotPassword,
                      colorString: AppColors.darkBlue,
                      fontNum: 40,
                      fontWeight: FontWeight.bold,
                    ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SharedText(
                        title: t.forgotPasswordMessage,
                        colorString: AppColors.darkBlue,
                        fontNum: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),
                    
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: SharedText(
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
                          _sendResetEmail(t);
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

                   ElevatedButton.icon(
                      onPressed: () {
                        _isLoading ? null : _sendResetEmail(t);
                      },

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
                      label: SharedText(
                        title: _isLoading ? t.sending : t.sendResetLink,
                        colorString: Colors.black,
                        fontNum: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                      child: SharedText(
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
}
