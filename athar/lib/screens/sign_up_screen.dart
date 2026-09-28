import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:athar/services/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/shared_text.dart';
import '../widgets/text_form_field.dart';
import '../theme/app_colors.dart';
import '../app_locale.dart' as app_locale;

class SignUpPage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  final bool isArabic;
  const SignUpPage({
    super.key,
    required this.onLanguageChanged,
    required this.isArabic,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.signInWithGoogle(isSignUp: true);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result.credential != null) {
      // نجح إنشاء الحساب
      Navigator.pushReplacementNamed(context, '/home');
    } else if (result.emailAlreadyExists) {
      // الإيميل مستخدم مسبقًا -> حوّله لصفحة تسجيل الدخول
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'هذا البريد مستخدم مسبقًا')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'فشل إنشاء الحساب')),
      );
    }
  }

  Future<void> _handleEmailSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.signUp(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل إنشاء الحساب')));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;

      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'كلمة المرور ضعيفة جدًا';
          break;
        case 'email-already-in-use':
          message = 'هذا البريد الإلكتروني مستخدم مسبقًا';
          break;
        case 'invalid-email':
          message = 'صيغة البريد الإلكتروني غير صحيحة';
          break;
        default:
          message = e.message ?? 'حدث خطأ أثناء إنشاء الحساب';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ غير متوقع: $e')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColorTrans,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold),
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
                          if (app_locale.isArabic) {
                            widget.onLanguageChanged(const Locale('en'));
                          } else {
                            widget.onLanguageChanged(const Locale('ar'));
                          }
                        },
                        icon: ImageIcon(
                          AssetImage('assets/images/translation.png'),
                          size: 30,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 65,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/userImage.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SharedText(
                      title: t.signUp,
                      colorString: AppColors.darkBlue,
                      fontNum: 35,
                    ),
                    SizedBox(height: 4),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldTrans,
                            spreadRadius: 7,
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SharedText(
                        title: t.signUpMessage,
                        colorString: AppColors.darkBlue,
                        fontNum: 12,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 10),

                    SharedTextFormField(
                      labelText: t.name,
                      hintText: t.enterName,
                      iconReq: Icons.person,
                      validator: (value) => validateName(value, t),
                      controller: _nameController,
                    ),

                    SizedBox(height: 7),

                    SharedTextFormField(
                      labelText: t.username,
                      hintText: t.enterUsername,
                      iconReq: Icons.person_outline_rounded,
                      validator: (value) => validateUsername(value, t),
                      controller: _usernameController,
                    ),
                    SizedBox(height: 7),
                    SharedTextFormField(
                      labelText: t.email,
                      hintText: t.enterEmail,
                      iconReq: Icons.email_outlined,
                      validator: (value) => validateEmail(value, t),
                      controller: _emailController,
                    ),
                    SizedBox(height: 7),
                    SharedTextFormField(
                      labelText: t.password,
                      hintText: t.enterPassword,
                      iconReq: Icons.password_outlined,
                      validator: (value) => validatePassword(value, t),
                      controller: _passwordController,
                      isSecure: true,
                    ),

                    SizedBox(height: 7.5),
                    
                    ElevatedButton.icon(
                      onPressed: _handleEmailSignUp,
                      style: ElevatedButton.styleFrom(
                        elevation: 7,
                        minimumSize: Size(70, 40),
                        //backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        shadowColor: AppColors.gold,
                      ),

                      icon: Icon(Icons.draw, size: 17, color: Colors.black),
                      label: SharedText(
                        title: t.signUp,
                        colorString: Colors.black,
                        fontNum: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    SharedText(
                      title: t.or,
                      colorString: AppColors.darkBlue,
                      fontNum: 10,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),

                    SizedBox(height: 4),

                    _isLoading
                        ? CircularProgressIndicator(color: AppColors.gold)
                        : ElevatedButton.icon(
                            onPressed: _handleGoogleSignUp,
                            style: ElevatedButton.styleFrom(
                              elevation: 7,
                              minimumSize: Size(70, 40),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                            icon: Image(
                              width: 30,
                              height: 30,
                              image: AssetImage('assets/images/google.png'),
                            ),

                            label: SharedText(
                              title: t.signUpWithGoogle,
                              colorString: AppColors.darkBlue,
                              fontNum: 17,
                            ),
                          ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SharedText(
                          title: t.alreadyHaveAccount,
                          colorString: AppColors.darkBlue,
                          fontNum: 13,
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: SharedText(
                            title: t.login,
                            colorString: AppColors.darkBlue,
                            fontNum: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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

  // =====================================================
  // Password Validator
  // =====================================================

  String? validatePassword(String? value, AppLocalizations t) {
    if (value == null || value.isEmpty) {
      return t.passwordRequired;
    }

    if (value.length < 8) {
      return t.passwordMinLength;
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return t.passwordUppercase;
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return t.passwordNumber;
    }

    return null;
  }

  // =====================================================
  // Email Validator
  // =====================================================

  String? validateEmail(String? value, AppLocalizations t) {
    if (value == null || value.trim().isEmpty) {
      return t.emailRequired;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return t.invalidEmail;
    }

    return null;
  }

  // =====================================================
  // Name Validator
  // =====================================================

  String? validateName(String? value, AppLocalizations t) {
    if (value == null || value.trim().isEmpty) {
      return t.nameRequired;
    }

    final name = value.trim();

    if (name.length < 2) {
      return t.invalidName;
    }

    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(name)) {
      return t.invalidName;
    }

    return null;
  }

  // Username Validator
  String? validateUsername(String? value, AppLocalizations t) {
    if (value == null || value.trim().isEmpty) {
      return t.usernameRequired;
    }

    final username = value.trim();

    if (username.length < 3 || username.length > 20) {
      return t.invalidUsername;
    }

    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_.]*$').hasMatch(username)) {
      return t.invalidUsername;
    }

    return null;
  }
}
