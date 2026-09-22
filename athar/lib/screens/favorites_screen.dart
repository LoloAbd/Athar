import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:athar/services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_text.dart';
import '../widgets/shared_snack_bar.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const FavoritesScreen({super.key, required this.onLanguageChanged});

  @override
  State<FavoritesScreen> createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  int selectedCategory = 0;
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> favoriteMessages = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // LOAD FAVORITES

  Future<void> loadFavorites() async {
    try {
      final data = await _authService.getFavoriteMessages();

      // إذا طلعنا من الصفحة اطلع من الفنكشن
      if (!mounted) return;

      setState(() {
        favoriteMessages = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading favorites: $e');
      if (!mounted) return;

      setState(() {
        favoriteMessages = [];
        isLoading = false;
      });
    }
  }

  // FILTER FAVORITES

  List<Map<String, dynamic>> getFilteredFavorites() {
    // ALL
    if (selectedCategory == 0) {
      return favoriteMessages;
    }

    // AYAT
    if (selectedCategory == 1) {
      return favoriteMessages.where((message) {
        final String type =
            message['type']?.toString().trim().toLowerCase() ?? '';
        return type == 'ayat';
      }).toList();
    }

    // Meassages
    if (selectedCategory == 2) {
      return favoriteMessages.where((message) {
        final String type =
            message['type']?.toString().trim().toLowerCase() ?? '';
        return type == 'message';
      }).toList();
    }

    // QUOTES
    if (selectedCategory == 3) {
      return favoriteMessages.where((message) {
        final String type =
            message['type']?.toString().trim().toLowerCase() ?? '';
        return type == 'quote';
      }).toList();
    }

    return favoriteMessages;
  }

  //Remove from favorites
  Future<void> removeFavorite(
    Map<String, dynamic> message,
    AppLocalizations t,
  ) async {
    final String? messageId = message['messageId']?.toString();

    if (messageId == null || messageId.isEmpty) {
      debugPrint('messageId is missing');
      return;
    }

    try {
      await _authService.removeFavoriteMessage(messageId);

      if (!mounted) return;

      setState(() {
        favoriteMessages.removeWhere(
          (item) => item['messageId']?.toString() == messageId,
        );
      });
      SharedSnackBar.showSuccess(
        context: context,
        message: t.messageRemovedFromFavorites,
      );
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final List<Map<String, dynamic>> filteredFavorites = getFilteredFavorites();
    final bool hasFilteredFavorites = filteredFavorites.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      body: SafeArea(
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.only(
                    start: 15,
                    end: 15,
                    top: 25,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SharedText(
                        title: t.favoriteMessages,
                        colorString: AppColors.darkBlue,
                        fontNum: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Icon(
                            Icons.auto_awesome,
                            size: 22,
                            color: AppColors.gold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsetsDirectional.only(start: 12, end: 12),
                  padding: const EdgeInsets.all(5),
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.favBordar, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.favBoxShadow,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCategoryButton(title: t.all, index: 0),
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: _buildCategoryButton(title: t.ayat, index: 1),
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: _buildCategoryButton(
                          title: t.messages,
                          index: 2,
                        ),
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: _buildCategoryButton(title: t.quotes, index: 3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                  )
                else if (!hasFilteredFavorites)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildEmptyFavorites(t),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: filteredFavorites
                          .map(
                            (message) =>
                                _buildFavoriteCard(message, isArabic, t),
                          )
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // EMPTY FAVORITES

  Widget _buildEmptyFavorites(AppLocalizations t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.emptyFavBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.favBordar, width: 1),
      ),

      child: Row(
        children: [
          SizedBox(
            width: 95,
            height: 90,
            child: Image.asset(
              'assets/images/empty_favorites.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SharedText(
                  title: t.emptyFavorites,
                  colorString: AppColors.darkBlue,
                  fontNum: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FAVORITE CARD

  Widget _buildFavoriteCard(
    Map<String, dynamic> message,
    bool isArabic,
    AppLocalizations t,
  ) {
    final String type = message['type']?.toString().trim() ?? '';

    final String text = isArabic
        ? (message['textAr'] ?? '').toString()
        : (message['textEn'] ?? '').toString();

    final String date = message['date']?.toString() ?? '';

    final String time = message['time']?.toString() ?? '';

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.favBordar),

        boxShadow: const [
          BoxShadow(
            color: AppColors.favBoxShadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SharedText(
                title: '“',
                colorString: AppColors.gold,
                fontNum: 38,
                fontWeight: FontWeight.bold,
              ),

              const Spacer(),

              IconButton(
                onPressed: () {
                  // Remove favorite
                },

                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.moreColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),

            child: SharedText(
              title: text,
              colorString: AppColors.darkBlue,
              fontNum: 16,
              fontWeight: FontWeight.w500,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.moreColor,
              ),

              const SizedBox(width: 5),

              Flexible(
                child: SharedText(
                  title: date,
                  colorString: AppColors.moreColor,
                  fontNum: 10,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),

              if (time.isNotEmpty) ...[
                const SizedBox(width: 6),
                const Text(
                  '•',
                  style: TextStyle(color: AppColors.moreColor, fontSize: 10),
                ),

                const SizedBox(width: 6),

                Flexible(
                  child: SharedText(
                    title: time,
                    colorString: AppColors.moreColor,
                    fontNum: 10,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: _getTypeBackground(type),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: SharedText(
                  title: type,
                  colorString: _getTypeColor(type),
                  fontNum: 10,
                ),
              ),

              const Spacer(),
            ],
          ),
          const SizedBox(height: 15),

          Align(
            alignment: AlignmentGeometry.centerStart,

            child: Expanded(
              child: ElevatedButton(
                onPressed: () {
                  removeFavorite(message, t);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.gold,
                      size: 20,
                    ),

                    const SizedBox(width: 6),

                    SharedText(
                      title: t.unfavorite,
                      colorString: AppColors.darkBlue,
                      fontNum: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CATEGORY BUTTON

  Widget _buildCategoryButton({required String title, required int index}) {
    final bool isSelected = selectedCategory == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.darkBlue : AppColors.primaryColor,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: AppColors.selectedCatButton,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SharedText(
              title: title,
              colorString: isSelected ? Colors.white : AppColors.darkBlue,
              fontNum: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              textAlign: TextAlign.center,
            ),

            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.favorite, size: 18, color: AppColors.gold),
            ],
          ],
        ),
      ),
    );
  }

  // TYPE COLORS

  Color _getTypeColor(String type) {
    switch (type.trim().toLowerCase()) {
      case 'ayat':
        return const Color(0xFF16866C);

      case 'quotes':
        return const Color(0xFF31589B);

      case 'messages':
        return const Color(0xFFB07A12);

      default:
        return AppColors.darkBlue;
    }
  }

  Color _getTypeBackground(String type) {
    switch (type.trim().toLowerCase()) {
      case 'ayat':
        return const Color(0xFFDFF3EB);

      case 'quotes':
        return const Color(0xFFE8EEFF);

      case 'messages':
        return const Color(0xFFFFF2D8);

      default:
        return AppColors.primaryColor;
    }
  }
}
