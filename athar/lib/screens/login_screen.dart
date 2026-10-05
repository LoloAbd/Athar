import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:athar/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/shared_text.dart';
import '../widgets/text_form_field.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_snack_bar.dart';
import '../app_locale.dart' as app_locale;

class LoginPage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  final bool isArabic;

  const LoginPage({
    super.key,
    required this.onLanguageChanged,
    required this.isArabic,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _handleGoogleLogin(AppLocalizations t) async {
    setState(() {
      _isLoading = true;
    });

    final result = await _authService.signInWithGoogle(isSignUp: false);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (result.credential != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      SharedSnackBar.showError(context: context, message: t.faildlogin);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // =====================================================
  // Load Remember Me
  // =====================================================

  Future<void> _loadSavedCredentials() async {
    final savedRememberMe = await _storage.read(key: "remember_me");

    if (savedRememberMe == "true") {
      final savedEmail = await _storage.read(key: "email");

      if (!mounted) return;

      setState(() {
        _rememberMe = true;

        if (savedEmail != null) {
          emailController.text = savedEmail;
        }
      });
    }
  }

  // =====================================================
  // Login
  // =====================================================

  Future<void> _handleLogin(AppLocalizations t) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // =====================================================
      // Remember Me
      // =====================================================

      if (_rememberMe) {
        await _storage.write(key: "remember_me", value: "true");
        await _storage.write(key: "email", value: emailController.text.trim());
      } else {
        await _storage.delete(key: "remember_me");
        await _storage.delete(key: "email");
      }

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = t.userNotFound;
          break;

        case 'wrong-password':
          message = t.passwordsDoNotMatch;
          break;

        case 'invalid-credential':
          message = t.invalidCredentials;
          break;

        case 'invalid-email':
          message = t.invalidEmail;
          break;

        case 'too-many-requests':
          message = t.faildlogin;
          break;

        default:
          message = t.faildlogin;
      }

      SharedSnackBar.showError(context: context, message: message);
    } catch (e) {
      if (!mounted) return;
      SharedSnackBar.showError(context: context, message: t.faildlogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = app_locale.isArabic;
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
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColorTrans,
                borderRadius: BorderRadius.circular(20),
                border: BoxBorder.all(color: AppColors.gold),
              ),

              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: IconButton(
                        onPressed: () => isArabic
                            ? widget.onLanguageChanged(const Locale('en'))
                            : widget.onLanguageChanged(const Locale('ar')),
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/userImage.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    SharedText(
                      title: t.welcomeBack,
                      colorString: AppColors.darkBlue,
                      fontNum: 35,
                    ),
                    const SizedBox(height: 5),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldTrans,
                            spreadRadius: 7,
                            blurRadius: 15,
                          ),
                        ],
                      ),

                      child: SharedText(
                        title: t.loginpMessage,
                        colorString: AppColors.darkBlue,
                        fontNum: 12,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 10),

                    SharedTextFormField(
                      labelText: t.email,
                      hintText: t.enterEmail,
                      iconReq: Icons.email_outlined,
                      controller: emailController,
                    ),

                    const SizedBox(height: 10),

                    SharedTextFormField(
                      labelText: t.password,
                      hintText: t.enterPassword,
                      iconReq: Icons.password_outlined,
                      controller: passwordController,
                      isSecure: true,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                                activeColor: AppColors.darkBlueBase,
                                checkColor: Colors.white,
                                side: BorderSide(
                                  color: AppColors.gold,
                                  width: 2,
                                ),
                              ),
                              Flexible(
                                child: SharedText(
                                  title: t.remmberMe,
                                  colorString: AppColors.darkBlue,
                                  fontNum: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotPassword');
                          },
                          child: SharedText(
                            title: t.forgotPassword,
                            colorString: AppColors.darkBlue,
                            fontNum: 11,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2.5),

                    ElevatedButton.icon(
                      onPressed: () => _handleLogin(t),
                      style: ElevatedButton.styleFrom(
                        elevation: 7,
                        minimumSize: const Size(70, 40),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        shadowColor: AppColors.gold,
                      ),
                      icon: const Icon(
                        Icons.login,
                        size: 17,
                        color: Colors.black,
                      ),
                      label: SharedText(
                        title: t.login,
                        colorString: AppColors.darkBlueBase,
                        fontNum: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    SharedText(
                      title: t.or,
                      colorString: AppColors.darkBlue,
                      fontNum: 10,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    const SizedBox(height: 5),

                    _isLoading
                        ? CircularProgressIndicator(color: AppColors.gold)
                        : ElevatedButton.icon(
                            onPressed: () => _handleGoogleLogin(t),
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
                              colorString: AppColors.darkBlueBase, 
                              fontNum: 17,
                            ),
                          ),
                    const SizedBox(height: 2.5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SharedText(
                            title: t.noAccount,
                            colorString: AppColors.darkBlue,
                            fontNum: 13,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: SharedText(
                            title: t.signUp,
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
}
