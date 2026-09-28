import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:athar/firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import '/athar_splash.dart';
import 'screens/main_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/schedule_message.dart';
import 'screens/random_message.dart';
import 'screens/random_person.dart';
import 'screens/edit_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_locale.dart' as app_locale;
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '988731721904-7rb1s33r7veg1m71355bgndkc5c2snjk.apps.googleusercontent.com',
    );
  }

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  static const _storage = FlutterSecureStorage();
  Locale? _locale;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    app_locale.isArabic =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ar';
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final savedValue = await _storage.read(key: 'darkMode');
      if (!mounted || savedValue == null) return;
      final isDark = savedValue == 'true';
      setState(() {
        _isDark = isDark;
        AppColors.isDark = isDark;
      });
    } catch (error) {
      debugPrint('Could not restore theme preference: $error');
    }
  }

  void setLocale(Locale locale) {
    app_locale.isArabic = locale.languageCode == 'ar';
    setState(() {
      _locale = locale;
    });
  }

  void setDarkMode(bool value) {
    setState(() {
      _isDark = value;
      AppColors.isDark = value;
    });
    _storage.write(key: 'darkMode', value: value.toString()).catchError((
      error,
    ) {
      debugPrint('Could not save theme preference: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color.fromARGB(255, 232, 241, 250),
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 34, 73, 116),
          secondary: Color(0xFFFFC107),
          surface: Color.fromARGB(255, 241, 246, 250),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 17, 42, 69),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 184, 203, 231),
          secondary: Color(0xFFFFC107),
          surface: Color.fromARGB(255, 34, 73, 116),
        ),
      ),
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: AtharSplashScreen(
        onLanguageChanged: setLocale,
        isArabic: app_locale.isArabic,
        onThemeChanged: setDarkMode,
      ),

      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/login':
            page = LoginPage(
              onLanguageChanged: setLocale,
              isArabic: app_locale.isArabic,
            );
            break;
          case '/signup':
            page = SignUpPage(
              onLanguageChanged: setLocale,
              isArabic: app_locale.isArabic,
            );
            break;
          case '/home':
            page = MainScreen(
              onLanguageChanged: setLocale,
              isArabic: app_locale.isArabic,
              onThemeChanged: setDarkMode,
            );
            break;
          case '/forgotPassword':
            page = ForgotPassword(
              onLanguageChanged: setLocale,
              isArabic: app_locale.isArabic,
            );
            break;
          case '/profilePage':
            page = ProfilePage();
            break;
          case '/schedule-message':
            page = ScheduleMessagePage(isArabic: app_locale.isArabic);
            break;
          case '/random-message':
            page = RandomMessagePage(isArabic: app_locale.isArabic);
            break;
          case '/random-user':
            page = RandomPersonPage(isArabic: app_locale.isArabic);
            break;
          //EditProfilePage
          case '/edit-profile':
            page = EditProfilePage();
            break;
          default:
            page = LoginPage(
              onLanguageChanged: setLocale,
              isArabic: app_locale.isArabic,
            );
        }
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 900),
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
