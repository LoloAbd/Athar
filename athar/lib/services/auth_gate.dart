import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class AuthGate extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const AuthGate({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return MainScreen(onLanguageChanged: onLanguageChanged);
        }

        return LoginPage(onLanguageChanged: onLanguageChanged);
      },
    );
  }
}
