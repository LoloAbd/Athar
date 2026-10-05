import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_text.dart';

class AboutScreen extends StatelessWidget {
  final bool isArabic;

  const AboutScreen({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final sections = isArabic
        ? [
            _AboutSection(
              icon: Icons.auto_awesome_rounded,
              title: 'قصتنا',
              body:
                  'أثر مساحة صغيرة للكلمات الطيبة؛ تجمع الرسائل الملهمة وتقرّبها منك، لترافق يومك وتترك في قلبك أثراً جميلاً.',
            ),
            _AboutSection(
              icon: Icons.favorite_outline_rounded,
              title: 'رسالتنا',
              body:
                  'نؤمن أن كلمة صادقة قد تغيّر يوماً كاملاً. لذلك صممنا أثر لتجد رسالة تناسب لحظتك، وتحفظ ما تحب، وتشارك الإلهام مع من حولك.',
            ),
            _AboutSection(
              icon: Icons.lightbulb_outline_rounded,
              title: 'كيف يصنع أثر فرقاً؟',
              body:
                  'اكتشف رسالة يومية، أضف كلماتك المفضلة، أو أرسل رسالة لشخص عزيز. كل تفاعل بسيط قد يصبح ذكرى طيبة وأثراً يبقى.',
            ),
          ]
        : [
            _AboutSection(
              icon: Icons.auto_awesome_rounded,
              title: 'Our story',
              body:
                  'Athar is a little space for kind words. It brings inspiring messages closer to you, to accompany your day and leave a good feeling behind.',
            ),
            _AboutSection(
              icon: Icons.favorite_outline_rounded,
              title: 'Our mission',
              body:
                  'We believe one sincere word can change an entire day. Athar helps you find a message for the moment, save what you love, and share inspiration with others.',
            ),
            _AboutSection(
              icon: Icons.lightbulb_outline_rounded,
              title: 'Make an impact',
              body:
                  'Discover a daily message, keep your favorites, or send a note to someone you care about. A small interaction can become a kind memory that lasts.',
            ),
          ];

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.darkBlue,
        title: SharedText(
          title: t.about,
          colorString: AppColors.darkBlue,
          fontNum: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.aboutImageColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aboutImageColor,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/appLogo.png'),
                    width: 150,
                    height: 170,
                  ),
                  const SizedBox(height: 8),
                  SharedText(
                    title: isArabic
                        ? 'كلمات طيبة، وأثر يبقى.'
                        : 'Kind words. A lasting impact.',
                    colorString: AppColors.primaryColor,
                    fontNum: 20,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...sections.map(
              (section) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: AppColors.secondaryColor,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: AppColors.favBordar),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: AppColors.gold.withValues(alpha: 0.12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.aboutImageColor,
                      child: Icon(section.icon, color: AppColors.primaryColor),
                    ),
                    title: SharedText(
                      title: section.title,
                      colorString: AppColors.darkBlue,
                      fontNum: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    childrenPadding: const EdgeInsetsDirectional.fromSTEB(
                      18,
                      0,
                      18,
                      18,
                    ),
                    children: [
                      SharedText(
                        title: section.body,
                        colorString: AppColors.secondaryText,
                        fontNum: 14,
                        maxLines: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSection {
  final IconData icon;
  final String title;
  final String body;

  const _AboutSection({
    required this.icon,
    required this.title,
    required this.body,
  });
}
