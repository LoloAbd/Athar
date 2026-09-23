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

class Homepage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const Homepage({super.key, required this.onLanguageChanged});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthService _authService = AuthService();

  String userName = '';
  Map<String, dynamic>? messages;
  Map<String, dynamic>? todayMessage;
  Map<String, dynamic>? reminderMessage;

  bool isLoadingMessage = true;
  bool isFav = false;
  bool haveNotification = false;

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
    await Future.wait([_loadUserData(), _loadRandomMessage()]);
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

    final bool isArabic =
        Localizations.localeOf(context).languageCode ==
        'ar'; // TODO: make it a global var

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
              leading: const ImageIcon(
                AssetImage('assets/images/translation.png'),
                size: 30,
                color: Color.fromARGB(255, 15, 20, 51),
              ),
              title: SharedText(
                title: t.language,
                colorString: const Color.fromARGB(255, 15, 20, 51),
                fontNum: 16,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: SharedText(
                        title: t.language,
                        colorString: const Color.fromARGB(255, 15, 20, 51),
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
                                  ? const Color(0xFFB8DAF0)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SharedText(
                              title: t.arabic,
                              colorString: const Color.fromARGB(
                                255,
                                15,
                                20,
                                51,
                              ),
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
                                  ? const Color(0xFFB8DAF0)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SharedText(
                              title: t.english,
                              colorString: const Color.fromARGB(
                                255,
                                15,
                                20,
                                51,
                              ),
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

            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                size: 30,
                color: Color.fromARGB(255, 15, 20, 51),
              ),
              title: SharedText(
                title: t.settings,
                colorString: const Color.fromARGB(255, 15, 20, 51),
                fontNum: 16,
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/edit-profile');
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.info_outline,
                size: 30,
                color: Color.fromARGB(255, 15, 20, 51),
              ),
              title: SharedText(
                title: t.about,
                colorString: const Color.fromARGB(255, 15, 20, 51),
                fontNum: 16,
              ),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
                color: Color.fromARGB(255, 15, 20, 51),
              ),
              title: SharedText(
                title: t.logout,
                colorString: const Color.fromARGB(255, 15, 20, 51),
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
                IconButton(
                  onPressed: () {},
                  // TODO: handle notifications
                  /*style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 40),
                    fixedSize: const Size(40, 40),
                  ),
                  */
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 35,
                    color: Colors.black,
                  ),
                ),

                if (haveNotification)
                  Positioned(
                    top: 11,
                    right: 11,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                    ),
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
                            colorString: Colors.black,
                            fontNum: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(width: 2),
                          SharedText(
                            title: userName,
                            colorString: Colors.black,
                            fontNum: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),

                      SharedText(
                        title: t.welcomeMessage,
                        colorString: Colors.black,
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
                                  colorString: Colors.black,
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
                                    const Icon(
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(
                              color: AppColors.lightGold,
                            ),
                          )
                        else if (todayMessage == null)
                          SharedText(
                            title: t.welcomeMessage,
                            colorString: Colors.black,
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
                            colorString: Colors.black,
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
                          decoration: const BoxDecoration(
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
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CircularProgressIndicator(
                                  color: AppColors.lightGold,
                                ),
                              )
                            else if (reminderMessage == null)
                              Expanded(
                                child: SharedText(
                                  title: t.reminderMessage,
                                  colorString: Colors.black,
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
                                  colorString: Colors.black,
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
