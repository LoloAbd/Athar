import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '988731721904-7rb1s33r7veg1m71355bgndkc5c2snjk.apps.googleusercontent.com',
  );
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: AtharSplashScreen(onLanguageChanged: setLocale),

      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/login':
            page = LoginPage(onLanguageChanged: setLocale);
            break;
          case '/signup':
            page = SignUpPage(onLanguageChanged: setLocale);
            break;
          case '/home':
            page = MainScreen(onLanguageChanged: setLocale);
            break;
          case '/forgotPassword':
            page = ForgotPassword(onLanguageChanged: setLocale);
            break;
          case '/profilePage':
            page = ProfilePage(onLanguageChanged: setLocale);
            break;
          case '/schedule-message':
            page = ScheduleMessagePage();
            break;
          case '/random-message':
            page = RandomMessagePage();
            break;
          case '/random-user':
            page = RandomPersonPage();
            break;
          //EditProfilePage
          case '/edit-profile':
            page = EditProfilePage();
            break;
          default:
            page = LoginPage(onLanguageChanged: setLocale);
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
