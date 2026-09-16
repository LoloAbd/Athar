import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:athar/services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_text.dart';

class ProfilePage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  const ProfilePage({super.key, required this.onLanguageChanged});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  String userName = '';
  String name = '';

  int favoritesCount = 0;
  int receivedMessagesCount = 0;
  DateTime? joinDate;

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadProfileStats();
  }

  Future<void> loadUserData() async {
    final userData = await _authService.getUserData();

    if (userData != null && mounted) {
      setState(() {
        userName = userData['username'] ?? '';
        name = userData['name'] ?? '';
      });
    }
  }

  Future<void> loadProfileStats() async {
    final favorites = await _authService.getFavoritesCount();
    final received = await _authService.getReceivedMessagesCount();
    final date = await _authService.getJoinDate();
    if (mounted) {
      setState(() {
        favoritesCount = favorites;
        receivedMessagesCount = received;
        joinDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,

        title: Column(
          spacing: 3,
          children: [
            SizedBox(height: 7),
            SharedText(
              title: t.profile,
              colorString: Colors.white,
              fontNum: 24,
              fontWeight: FontWeight.bold,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(top: 5),
                  width: 80,
                  height: 2,
                  color: AppColors.gold,
                ),
                Icon(Icons.auto_awesome, size: 22, color: AppColors.gold),
                Container(
                  margin: EdgeInsetsDirectional.only(top: 5),
                  width: 80,
                  height: 2,
                  color: AppColors.gold,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: ClipPath(
          clipper: CurvedTopClipper(),

          child: Container(
            color: AppColors.primaryColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold, width: 3.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.background.withValues(
                                alpha: 0.5,
                              ),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 65.0,
                          backgroundImage: AssetImage(
                            'assets/images/loginProf.jpg',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  SharedText(
                    title: name,
                    colorString: const Color.fromARGB(255, 3, 11, 66),
                    fontNum: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  SharedText(
                    title: '@$userName',
                    colorString: const Color.fromARGB(255, 3, 31, 129),
                    fontNum: 16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(Icons.auto_awesome, size: 22, color: AppColors.gold),

                      SharedText(
                        title: t.profileMessage,
                        colorString: Colors.grey[700]!,
                        fontNum: 16,
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.auto_awesome, size: 22, color: AppColors.gold),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsetsDirectional.all(15),
                    padding: const EdgeInsetsDirectional.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.gold, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          spacing: 2,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.iconBackground,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.chat,
                                color: AppColors.background,
                                size: 30,
                              ),
                            ),
                            SharedText(
                              title: receivedMessagesCount.toString(),
                              colorString: Colors.black,
                              fontNum: 14,
                            ),
                            SharedText(
                              title: t.messages,
                              colorString: Colors.black,
                              fontNum: 14,
                            ),
                          ],
                        ),
                        Container(width: 2, height: 70, color: AppColors.gold),

                        Column(
                          spacing: 2,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.iconBackground,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: AppColors.background,
                                size: 30,
                              ),
                            ),
                            SharedText(
                              title: favoritesCount.toString(),
                              colorString: Colors.black,
                              fontNum: 14,
                            ),
                            SharedText(
                              title: t.favorites,
                              colorString: Colors.black,
                              fontNum: 14,
                            ),
                          ],
                        ),
                        Container(width: 2, height: 70, color: AppColors.gold),
                        Column(
                          spacing: 2,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.iconBackground,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: AppColors.background,
                                size: 30,
                              ),
                            ),
                            SharedText(
                              title: joinDate != null
                                  ? '${joinDate!.day}/${joinDate!.month}/${joinDate!.year}'
                                  : 'Unknown',
                              colorString: Colors.black,
                              fontNum: 14,
                            ),
                            SharedText(
                              title: t.datesjoin,
                              colorString: Colors.black,
                              fontNum: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsetsDirectional.only(
                      bottom: 15,
                      start: 20,
                      end: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 22,
                          color: AppColors.gold,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.77,
                          height: 1.5,
                          color: AppColors.gold,
                        ),
                        Icon(
                          Icons.auto_awesome,
                          size: 22,
                          color: AppColors.gold,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 15,
                      bottom: 10,
                      end: 15,
                    ),
                    padding: EdgeInsetsDirectional.only(
                      start: 10,
                      top: 15,
                      bottom: 10,
                      end: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 184, 218, 245),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 73, 121, 169),
                          blurRadius: 5,
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/messagesBackground.jpg',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 15,
                      children: [
                        Image(
                          image: AssetImage('assets/images/message.png'),
                          width: 40,
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SharedText(
                              title: t.profileTitle,
                              colorString: Colors.black,
                              fontNum: 13,
                            ),
                            SizedBox(height: 5),
                            SharedText(
                              title: t.profileSubtitle,
                              colorString: Colors.black,
                              fontNum: 12,
                            ),
                          ],
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.center,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
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
      ),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);

    path.quadraticBezierTo(size.width * 0.25, 35, size.width * 0.5, 20);

    path.quadraticBezierTo(size.width * 0.75, 5, size.width, 5);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
