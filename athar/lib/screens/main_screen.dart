import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import '../theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const MainScreen({super.key, required this.onLanguageChanged});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final GlobalKey<FavoritesScreenState> favoritesKey =
      GlobalKey<FavoritesScreenState>();

  final GlobalKey<HistoryScreenState> historyKey =
      GlobalKey<HistoryScreenState>();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final List<Widget> pages = [
      Homepage(onLanguageChanged: widget.onLanguageChanged),
      FavoritesScreen(
        key: favoritesKey,
        onLanguageChanged: widget.onLanguageChanged,
      ),
      HistoryScreen(
        key: historyKey,
        onLanguageChanged: widget.onLanguageChanged,
      ),
      ProfilePage(onLanguageChanged: widget.onLanguageChanged),
    ];

    return Scaffold(
      extendBody: false,
      body: IndexedStack(index: _currentIndex, children: pages),

      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Container(
          padding: const EdgeInsetsDirectional.only(top: 5, bottom: 7),
          decoration: BoxDecoration(
            color: AppColors.navigationBarBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.navigationBarBorder, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.navigationBarBackground,
              selectedItemColor: AppColors.navigationBarSelected,
              unselectedItemColor: AppColors.navigationBarUnselected,
              selectedLabelStyle: GoogleFonts.getFont(
                isArabic ? 'Almarai' : 'Alike',
                fontSize: 12,
              ),
              unselectedLabelStyle: GoogleFonts.getFont(
                isArabic ? 'Almarai' : 'Alike',
                fontSize: 12,
              ),
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                if (index == 1) {
                  favoritesKey.currentState?.loadFavorites();
                }
                if (index == 2) {
                  historyKey.currentState?.loadHistory();
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined, size: 30),
                  activeIcon: const Icon(Icons.home, size: 30),
                  label: t.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_border, size: 30),
                  activeIcon: const Icon(Icons.favorite, size: 30),
                  label: t.favorites,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.history_outlined, size: 30),
                  activeIcon: const Icon(Icons.history, size: 30),
                  label: t.history,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline, size: 30),
                  activeIcon: const Icon(Icons.person, size: 30),
                  label: t.account,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
