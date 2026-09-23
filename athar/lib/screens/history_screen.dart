import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:athar/services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_text.dart';

class HistoryScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const HistoryScreen({super.key, required this.onLanguageChanged});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  int selectedCategory = 0;
  final TextEditingController searchController = TextEditingController();
  String searchText = '';

  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> historyMessages = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // LOAD HISTORY
  Future<void> loadHistory() async {
    try {
      final data = await _authService.getHistoryMessages();
      if (!mounted) return;
      setState(() {
        historyMessages = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading history: $e');
      if (!mounted) return;
      setState(() {
        historyMessages = [];
        isLoading = false;
      });
    }
  }

  // FILTER HISTORY
  List<Map<String, dynamic>> getFilteredHistory(bool isArabic) {
    List<Map<String, dynamic>> result = historyMessages;

    // ALL
    if (selectedCategory == 0) {
      result = historyMessages;
    }
    // MESSAGES
    else if (selectedCategory == 1) {
      result = historyMessages.where((item) {
        final String type = item['type']?.toString().trim().toLowerCase() ?? '';

        return type == 'message';
      }).toList();
    }
    // QUOTES
    else if (selectedCategory == 2) {
      result = historyMessages.where((item) {
        final String type = item['type']?.toString().trim().toLowerCase() ?? '';

        return type == 'quote';
      }).toList();
    }
    // AYAT
    else if (selectedCategory == 3) {
      result = historyMessages.where((item) {
        final String type = item['type']?.toString().trim().toLowerCase() ?? '';

        return type == 'ayat';
      }).toList();
    }

    // SEARCH
    if (searchText.trim().isNotEmpty) {
      final String search = searchText.trim().toLowerCase();

      result = result.where((item) {
        final String message = isArabic
            ? (item['textAr'] ?? '').toString().toLowerCase()
            : (item['textEn'] ?? '').toString().toLowerCase();

        return message.contains(search);
      }).toList();
    }

    return result;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final List<Map<String, dynamic>> filteredHistory = getFilteredHistory(
      isArabic,
    );
    final bool hasFilteredHistory = filteredHistory.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: SharedText(
          title: t.history,
          colorString: AppColors.darkBlue,
          fontNum: 25,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ),

      body: SafeArea(
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 15, 18, 10),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.emptyFavBackground,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.secondaryColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCategoryButton(title: t.all, index: 0),
                      ),
                      Expanded(
                        child: _buildCategoryButton(title: t.ayat, index: 3),
                      ),
                      Expanded(
                        child: _buildCategoryButton(
                          title: t.messages,
                          index: 1,
                        ),
                      ),
                      Expanded(
                        child: _buildCategoryButton(title: t.quotes, index: 2),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),

                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(28),
                  ),

                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },

                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,

                    style: GoogleFonts.getFont(
                      isArabic ? 'Almarai' : 'Alike',
                      color: AppColors.darkBlue,
                      fontSize: 14,
                    ),

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.secondaryText,
                        size: 27,
                      ),

                      hintText: t.search,
                      hintStyle: GoogleFonts.getFont(
                        isArabic ? 'Almarai' : 'Alike',
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),

                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      )
                    : hasFilteredHistory
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 25),
                        itemCount: filteredHistory.length,
                        itemBuilder: (context, index) {
                          final message = filteredHistory[index];

                          return _buildHistoryCard(message, isArabic, t);
                        },
                      )
                    : _buildEmptyHistory(t),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HISTORY CARD
  Widget _buildHistoryCard(
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
    return GestureDetector(
      onTap: () => _showMessageDialog(message, isArabic),

      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.favBordar),
          boxShadow: const [
            BoxShadow(
              color: AppColors.favBoxShadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTypeIcon(type),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SharedText(
                    title: text,
                    colorString: AppColors.darkBlue,
                    fontNum: 15,
                    fontWeight: FontWeight.w500,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: _getTypeBackground(type),

                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: SharedText(
                          title: type == 'quote'
                              ? t.quotes
                              : type == 'message'
                              ? t.messages
                              : t.ayat,
                          colorString: _getTypeColor(type),
                          fontNum: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Flexible(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: AppColors.moreColor,
                            ),

                            const SizedBox(width: 4),

                            Flexible(
                              child: SharedText(
                                title: date,
                                colorString: AppColors.secondaryText,
                                fontNum: 8,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),

                            if (time.isNotEmpty) ...[
                              const SizedBox(width: 4),

                              const Text(
                                '•',
                                style: TextStyle(
                                  color: AppColors.moreColor,
                                  fontSize: 8,
                                ),
                              ),

                              const SizedBox(width: 4),

                              Flexible(
                                child: SharedText(
                                  title: time,
                                  colorString: AppColors.secondaryText,
                                  fontNum: 8,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            Icon(
              isArabic
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              color: AppColors.moreColor,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  // TYPE ICON
  Widget _buildTypeIcon(String type) {
    IconData icon;

    switch (type.trim().toLowerCase()) {
      case 'message':
        icon = Icons.chat_bubble_outline_rounded;
        break;

      case 'quote':
        icon = Icons.format_quote_rounded;
        break;

      case 'ayat':
        icon = Icons.menu_book_rounded;
        break;

      default:
        icon = Icons.history_rounded;
    }

    return Container(
      width: 58,
      height: 58,

      decoration: BoxDecoration(
        color: _getTypeBackground(type),
        shape: BoxShape.circle,
      ),

      child: Icon(icon, color: _getTypeColor(type), size: 27),
    );
  }

  // TYPE COLORS
  Color _getTypeColor(String type) {
    switch (type.trim().toLowerCase()) {
      case 'message':
        return const Color(0xFFB07A12);

      case 'quote':
        return const Color(0xFF31589B);

      case 'ayat':
        return const Color(0xFF16866C);

      default:
        return AppColors.darkBlue;
    }
  }

  Color _getTypeBackground(String type) {
    switch (type.trim().toLowerCase()) {
      case 'message':
        return const Color(0xFFFFF2D8);

      case 'quote':
        return const Color(0xFFE8EEFF);

      case 'ayat':
        return const Color(0xFFDFF3EB);

      default:
        return AppColors.primaryColor;
    }
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
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,

          borderRadius: BorderRadius.circular(25),
        ),

        child: SharedText(
          title: title,

          colorString: isSelected ? Colors.white : AppColors.darkBlue,

          fontNum: 11,

          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,

          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // EMPTY HISTORY

  Widget _buildEmptyHistory(AppLocalizations t) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 95,
              height: 95,

              decoration: const BoxDecoration(
                color: Color(0xFFFFF7E5),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.history_rounded,
                color: AppColors.gold,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            SharedText(
              title: t.noHistory,
              colorString: AppColors.darkBlue,
              fontNum: 18,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            SharedText(
              title: t.emptyHistory,
              colorString: AppColors.secondaryText,
              fontNum: 12,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // MESSAGE DETAILS POPUP
  void _showMessageDialog(Map<String, dynamic> message, bool isArabic) {
    final String type = message['type']?.toString().trim() ?? '';
    final String text = isArabic
        ? (message['textAr'] ?? '').toString()
        : (message['textEn'] ?? '').toString();
    final String date = message['date']?.toString() ?? '';
    final String time = message['time']?.toString() ?? '';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _buildTypeIcon(type),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeBackground(type),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SharedText(
                            title: type,
                            colorString: _getTypeColor(type),
                            fontNum: 18,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.moreColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // FULL MESSAGE TEXT
                  SingleChildScrollView(
                    child: SharedText(
                      title: text,
                      colorString: AppColors.darkBlue,
                      fontNum: 16,
                      fontWeight: FontWeight.w500,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      maxLines: 100,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: AppColors.moreColor,
                      ),
                      const SizedBox(width: 5),
                      SharedText(
                        title: date,
                        colorString: AppColors.secondaryText,
                        fontNum: 10,
                      ),
                      if (time.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        const Text(
                          '•',
                          style: TextStyle(
                            color: AppColors.moreColor,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 6),
                        SharedText(
                          title: time,
                          colorString: AppColors.secondaryText,
                          fontNum: 10,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



}
