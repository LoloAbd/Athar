// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:athar/services/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_text.dart';
import '../widgets/section_header.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/shared_snack_bar.dart';
import '../services/random_message_service.dart';
import 'notifications_screen.dart';
import 'about_screen.dart';
import '../app_locale.dart' as app_locale;

class Homepage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  final bool isArabic;
  final ValueChanged<bool> onThemeChanged;

  const Homepage({
    super.key,
    required this.onLanguageChanged,
    required this.isArabic,
    required this.onThemeChanged,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthService _authService = AuthService();
  late bool _isDark = AppColors.isDark;

  void _setTheme(bool value) {
    setState(() => _isDark = value);
    widget.onThemeChanged(value);
  }

  String userName = '';
  Map<String, dynamic>? messages;
  Map<String, dynamic>? todayMessage;
  Map<String, dynamic>? reminderMessage;

  bool isLoadingMessage = true;
  bool isFav = false;
  final RandomMessageService _userMessages = RandomMessageService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRandomMessage();
    _loadReminderMessage();
  }

  Future<void> _loadUserData() async {
    final name = await _authService.getUserName();

    if (mounted && name != null) {
      setState(() {
        userName = name;
      });
    }
  }

  // Get random message
  Future<void> _loadRandomMessage() async {
    if (!mounted) return;
    setState(() {
      isLoadingMessage = true;
    });

    try {
      final user = _authService.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          todayMessage = null;
          isFav = false;
          isLoadingMessage = false;
        });

        return;
      }

      final latestMessage = await _authService.getLatestHistoryMessage();

      if (latestMessage != null) {
        final nextAvailableAt = latestMessage['nextAvailableAt'];

        if (nextAvailableAt is Timestamp) {
          final now = DateTime.now();
          final nextTime = nextAvailableAt.toDate();

          if (now.isBefore(nextTime)) {
            final messageId = latestMessage['messageId'].toString();

            final favorite = await _authService.isFavorite(messageId);

            if (!mounted) return;

            setState(() {
              todayMessage = latestMessage;
              isFav = favorite;
              isLoadingMessage = false;
            });

            return;
          }
        }
      }

      final newMessage = await _authService.getRandomMessage();

      if (newMessage == null) {
        if (!mounted) return;

        setState(() {
          todayMessage = latestMessage;
          isLoadingMessage = false;
        });

        return;
      }

      final messageId = newMessage['messageId'].toString();

      final favorite = await _authService.isFavorite(messageId);

      if (!mounted) return;

      setState(() {
        todayMessage = newMessage;
        isFav = favorite;
        isLoadingMessage = false;
      });
    } catch (e) {
      debugPrint('Error loading random message: $e');

      if (!mounted) return;

      setState(() {
        isLoadingMessage = false;
      });
    }
  }

  // Get reminder message

  Future<void> _loadReminderMessage() async {
    if (!mounted) return;
    setState(() {
      isLoadingMessage = true;
    });

    try {
      final newMessage = await _authService.getReminderMessage();

      if (!mounted) return;

      setState(() {
        reminderMessage = newMessage;
        isLoadingMessage = false;
      });
      return;
    } catch (e) {
      debugPrint('Error loading random message: $e');
      if (!mounted) return;

      setState(() {
        isLoadingMessage = false;
      });
    }
  }

  // Called by RefreshIndicator when the user pulls down to refresh
  Future<void> _handleRefresh() async {
    await Future.wait([
      _loadUserData(),
      _loadRandomMessage(),
      _loadReminderMessage(),
    ]);
  }

  // Add to favorites
  Future<void> addToFavorites(
    Map<String, dynamic> message,
    AppLocalizations t,
  ) async {
    final String? messageId = message['messageId']?.toString();
    if (messageId == null || messageId.isEmpty) {
      debugPrint('messageId is missing');
      return;
    }
    try {
      await _authService.addFavoriteMessage(messageId, message);
      if (!mounted) return;
      SharedSnackBar.showSuccess(context: context, message: t.favorite);
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final bool isArabic = widget.isArabic;

    final DateTime now = DateTime.now();
    final int hour = now.hour;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.primaryColor,

      drawer: Drawer(
        backgroundColor: AppColors.primaryColor,
        child: ListView(
          children: [
            SizedBox(height: 30),
            ListTile(
              leading: ImageIcon(
                AssetImage('assets/images/translation.png'),
                size: 30,
                color: AppColors.darkBlue,
              ),
              title: SharedText(
                title: t.language,
                colorString: AppColors.darkBlue,
                fontNum: 16,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: SharedText(
                        title: t.language,
                        colorString: AppColors.darkBlue,
                        fontNum: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            widget.onLanguageChanged(const Locale('ar'));
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? AppColors.iconBackground
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SharedText(
                              title: t.arabic,
                              colorString: AppColors.darkBlue,
                              fontNum: 16,
                            ),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            widget.onLanguageChanged(const Locale('en'));
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'en'
                                  ? AppColors.iconBackground
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SharedText(
                              title: t.english,
                              colorString: AppColors.darkBlue,
                              fontNum: 16,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            SwitchListTile(
              secondary: Icon(
                _isDark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: AppColors.darkBlue,
              ),
              title: SharedText(
                title: _isDark ? t.lightMode : t.darkMode,
                colorString: AppColors.darkBlue,
                fontNum: 16,
              ),
              value: _isDark,
              activeThumbColor: AppColors.gold,
              onChanged: (value) {
                _setTheme(value);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                size: 30,
                color: AppColors.darkBlue,
              ),
              title: SharedText(
                title: t.settings,
                colorString: AppColors.darkBlue,
                fontNum: 16,
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/edit-profile');
              },
            ),

            ListTile(
              leading: Icon(
                Icons.info_outline,
                size: 30,
                color: AppColors.darkBlue,
              ),
              title: SharedText(
                title: t.about,
                colorString: AppColors.darkBlue,
                fontNum: 16,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AboutScreen(isArabic: isArabic),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.logout, size: 30, color: AppColors.darkBlue),
              title: SharedText(
                title: t.logout,
                colorString: AppColors.darkBlue,
                fontNum: 16,
              ),
              onTap: () async {
                try {
                  await _authService.logout();

                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  debugPrint('Logout error: ${e.code}');

                  if (context.mounted) {
                    SharedSnackBar.showError(
                      context: context,
                      message: t.logoutFaild,
                    );
                  }
                } catch (e) {
                  debugPrint('Logout error: $e');

                  if (context.mounted) {
                    SharedSnackBar.showError(
                      context: context,
                      message: t.serverError,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Builder(
          builder: (context) {
            return Container(
              margin: const EdgeInsetsDirectional.only(start: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(45, 45),
                  fixedSize: const Size(45, 45),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.menu, size: 25, color: Colors.white),
              ),
            );
          },
        ),

        title: Image.asset(
          'assets/images/appLogo.png',
          height: 75,
          fit: BoxFit.contain,
        ),

        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 5),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                StreamBuilder(
                  stream: _userMessages.getUnreadNotifications(),
                  builder: (context, snapshot) {
                    return StreamBuilder<int>(
                      stream: Stream<int>.periodic(
                        const Duration(seconds: 1),
                        (tick) => tick,
                      ),
                      builder: (context, _) {
                        final now = DateTime.now();
                        final unreadCount =
                            snapshot.data?.docs.where((doc) {
                              final data = doc.data();
                              if (data['isRead'] == true) return false;
                              final rawTime = data['scheduledAt'];
                              if (data['type'] == 'scheduled_user_message' &&
                                  rawTime is! Timestamp) {
                                return false;
                              }
                              return rawTime is! Timestamp ||
                                  !now.isBefore(rawTime.toDate());
                            }).length ??
                            0;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationsScreen(
                                    isArabic: app_locale.isArabic,
                                  ),
                                ),
                              ),
                              icon: Icon(
                                Icons.inbox_outlined,
                                size: 40,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                top: 3,
                                right: 2,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 21,
                                    minHeight: 21,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: SharedText(
                                    title: unreadCount > 99
                                        ? '99+'
                                        : '$unreadCount',
                                    colorString: AppColors.darkBlueBase,
                                    fontNum: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.gold,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 20, start: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SharedText(
                            title: hour <= 12
                                ? t.goodMorning
                                : hour >= 18
                                ? t.goodAfternoon
                                : t.goodEvening,
                            colorString: AppColors.darkBlue,
                            fontNum: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 2),
                          SharedText(
                            title: userName,
                            colorString: AppColors.darkBlue,
                            fontNum: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),

                      SharedText(
                        title: t.welcomeMessage,
                        colorString: AppColors.darkBlue,
                        fontNum: 14,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.only(
                    start: 10,
                    top: 18,
                    end: 10,
                    bottom: 15,
                  ),
                  padding: const EdgeInsetsDirectional.only(
                    top: 10,
                    start: 15,
                    end: 10,
                  ),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/messagesBackground.jpg'),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.white, blurRadius: 50),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsetsDirectional.only(
                                start: 40,
                              ),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.borderColor,
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/bird.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 7),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SharedText(
                                  title: t.todayMessage,
                                  colorString: AppColors.darkBlueBase,
                                  fontNum: 15,
                                  fontWeight: FontWeight.bold,
                                ),

                                const SizedBox(height: 3),

                                Row(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      height: 1.5,
                                      color: AppColors.lightGold,
                                    ),
                                    Icon(
                                      Icons.auto_awesome,
                                      size: 20,
                                      color: AppColors.lightGold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        if (isLoadingMessage)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(
                              color: AppColors.lightGold,
                            ),
                          )
                        else if (todayMessage == null)
                          SharedText(
                            title: t.welcomeMessage,
                            colorString: AppColors.darkBlueBase,
                            fontNum: 18,
                            textAlign: TextAlign.center,
                            shadow: const [
                              Shadow(color: Colors.white, blurRadius: 30),
                            ],
                            fontWeight: FontWeight.bold,
                          )
                        else
                          SharedText(
                            title: isArabic
                                ? (todayMessage!['textAr'] ?? '').toString()
                                : (todayMessage!['textEn'] ?? '').toString(),
                            colorString: AppColors.darkBlueBase,
                            fontNum: 18,
                            textAlign: TextAlign.center,
                            shadow: const [
                              Shadow(color: Colors.white, blurRadius: 30),
                            ],
                            fontWeight: FontWeight.bold,
                            maxLines: 100,
                          ),

                        const SizedBox(height: 15),

                        Container(
                          margin: const EdgeInsetsDirectional.only(bottom: 15),
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.favButtonBackground,
                            shape: BoxShape.circle,
                          ),

                          child: Expanded(
                            child: ElevatedButton(
                              onPressed: todayMessage == null
                                  ? null
                                  : () async {
                                      final messageId =
                                          todayMessage!['messageId'].toString();
                                      try {
                                        if (isFav) {
                                          await _authService
                                              .removeFavoriteMessage(messageId);
                                        } else {
                                          await _authService.addFavoriteMessage(
                                            messageId,
                                            todayMessage!,
                                          );
                                        }
                                        if (!mounted) return;
                                        setState(() {
                                          isFav = !isFav;
                                        });
                                        final message = isFav
                                            ? t.messageAddedToFavorites
                                            : t.messageRemovedFromFavorites;

                                        SharedSnackBar.showSuccess(
                                          context: context,
                                          message: message,
                                        );
                                      } catch (e) {
                                        debugPrint(
                                          'Error changing favorite: $e',
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryColor,
                                elevation: 7,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27),
                                ),
                              ),
                              child: isFav
                                  ? Icon(
                                      Icons.favorite_rounded,
                                      color: AppColors.gold,
                                      size: 25,
                                    )
                                  : Icon(
                                      Icons.favorite_outline,
                                      color: AppColors.gold,
                                      size: 25,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Actions
                Container(
                  margin: const EdgeInsetsDirectional.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: t.quickActions),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9,
                        children: [
                          QuickActionCard(
                            image: 'assets/images/Schedule.png',
                            title: t.scheduleMessage,
                            fontSize: 14,
                            onTap: () {
                              Navigator.pushNamed(context, '/schedule-message');
                            },
                          ),
                          QuickActionCard(
                            image: 'assets/images/random.png',
                            title: t.randomTime,
                            fontSize: 14,
                            onTap: () {
                              Navigator.pushNamed(context, '/random-message');
                            },
                          ),
                          QuickActionCard(
                            image: 'assets/images/randomUser.png',
                            title: t.randomUser,
                            imageWidth: 60,
                            imageHeight: 50,
                            fontSize: 14,
                            onTap: () {
                              Navigator.pushNamed(context, '/random-user');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --------------------------------------------------
                // Reminder
                // --------------------------------------------------
                Container(
                  margin: const EdgeInsetsDirectional.only(
                    start: 15,
                    bottom: 10,
                    end: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: t.reminder),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.only(
                          start: 5,
                          end: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 241, 251),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 73, 121, 169),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: hour >= 18
                                  ? const AssetImage('assets/images/cloudy.png')
                                  : const AssetImage('assets/images/sun.png'),
                              width: 75,
                              height: 75,
                            ),
                            const SizedBox(width: 10),
                            if (isLoadingMessage)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CircularProgressIndicator(
                                  color: AppColors.lightGold,
                                ),
                              )
                            else if (reminderMessage == null)
                              Expanded(
                                child: SharedText(
                                  title: t.reminderMessage,
                                  colorString: AppColors.darkBlueBase,
                                  fontNum: 13,
                                  textAlign: TextAlign.start,
                                  shadow: const [
                                    Shadow(color: Colors.white, blurRadius: 30),
                                  ],
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              Expanded(
                                child: SharedText(
                                  title: isArabic
                                      ? (reminderMessage!['arabic'] ?? '')
                                            .toString()
                                      : (reminderMessage!['english'] ?? '')
                                            .toString(),
                                  colorString: AppColors.darkBlueBase,
                                  fontNum: 13,
                                  textAlign: TextAlign.start,
                                  shadow: const [
                                    Shadow(color: Colors.white, blurRadius: 30),
                                  ],
                                  fontWeight: FontWeight.bold,
                                  maxLines: 2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
