import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/random_message_service.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_text.dart';
import '../widgets/shared_snack_bar.dart';

class RandomPersonPage extends StatefulWidget {
  const RandomPersonPage({super.key});

  @override
  State<RandomPersonPage> createState() => _RandomPersonPageState();
}

class _RandomPersonPageState extends State<RandomPersonPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  final RandomMessageService _messageService = RandomMessageService();

  static const int _maxChars = 500;

  Map<String, dynamic>? _selectedUser;

  bool _isFindingUser = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_refresh);
    _messageFocus.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_refresh);
    _messageFocus.removeListener(_refresh);
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  // =====================================================
  // Pick Random User
  // =====================================================

  Future<void> _pickRandomUser(AppLocalizations t) async {
    if (_isFindingUser) return;

    setState(() {
      _isFindingUser = true;
    });

    try {
      final user = await _messageService.getRandomUser();

      if (!mounted) return;

      setState(() {
        _selectedUser = user;
        _isFindingUser = false;
      });

      if (user == null) {
        SharedSnackBar.showError(
          context: context,
          message: t.noOtherUsersAvailable,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isFindingUser = false;
      });

      SharedSnackBar.showError(
        context: context,
        message: t.couldNotFindRandomUser,
      );
    }
  }

  // =====================================================
  // Send Message
  // =====================================================

  Future<void> _sendMessage(AppLocalizations t) async {
    FocusScope.of(context).unfocus();

    final message = _messageController.text.trim();

    if (message.isEmpty) {
      SharedSnackBar.showError(
        context: context,
        message: t.writeYourMessageFirst,
      );
      return;
    }

    if (_selectedUser == null) {
      SharedSnackBar.showError(
        context: context,
        message: t.pickARandomUserFirst,
      );
      return;
    }

    final receiverUid = _selectedUser!['uid'] as String;
    final receiverUsername = _selectedUser!['username'] as String;

    setState(() {
      _isSending = true;
    });

    try {
      await _messageService.sendMessageToUser(
        message: message,
        receiverId: receiverUid,
        receiverUsername: receiverUsername,
      );

      if (!mounted) return;

      setState(() {
        _isSending = false;
      });

      SharedSnackBar.showSuccess(
        context: context,
        message: t.messageSentSuccessfully,
      );

      // Clear after successful sending
      _messageController.clear();

      setState(() {
        _selectedUser = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
      });

      SharedSnackBar.showError(context: context, message: t.messageWasNotSent);
    }
  }

  // =====================================================
  // Build
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          icon: const Icon(Icons.arrow_back),
        ),

        title: SharedText(
          title: t.randomMessage,
          colorString: AppColors.darkBlue,
          fontNum: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColor, Colors.white],
            stops: [0.0, 0.75],
          ),
        ),

        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(t),
                  const SizedBox(height: 26),
                  _buildMessageSection(t, isArabic),
                  const SizedBox(height: 26),
                  _buildRandomUserSection(t),
                  const SizedBox(height: 28),
                  _buildSendButton(t),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // Header
  // =====================================================

  Widget _buildHeader(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkBlue, Color(0xFF16305A)],
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlue.withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: AppColors.gold, width: 1.6),
            ),
            child: const Icon(
              Icons.mark_unread_chat_alt_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          SharedText(
            title: t.sendKindnessToSomeone,
            colorString: Colors.white,
            fontNum: 20,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SharedText(
            title: t.writeAMessageAndLetUsFindSomeone,
            colorString: Colors.white.withValues(alpha: 0.75),
            fontNum: 13,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Message Section
  // =====================================================

  Widget _buildMessageSection(AppLocalizations t, bool isArabic) {
    final focused = _messageFocus.hasFocus;
    final length = _messageController.text.characters.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(t.yourMessage, t.writeSomethingKind),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: focused ? AppColors.darkBlue : AppColors.gold,
              width: focused ? 1.6 : 1.0,
            ),

            boxShadow: [
              BoxShadow(
                color: focused
                    ? AppColors.darkBlue.withValues(alpha: 0.10)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: focused ? 18 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _messageController,
                focusNode: _messageFocus,
                maxLines: 7,
                minLines: 5,
                maxLength: _maxChars,
                textInputAction: TextInputAction.newline,
                textAlignVertical: TextAlignVertical.top,
                cursorColor: AppColors.darkBlue,
                style: GoogleFonts.getFont(
                  isArabic ? 'Almarai' : 'Alike',
                  textStyle: const TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 15,
                  ),
                ),

                decoration: InputDecoration(
                  counterText: '',
                  hintText: t.writeYourRandomMessage,
                  hintStyle: GoogleFonts.getFont(
                    isArabic ? 'Almarai' : 'Alike',
                    textStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              SharedText(
                title: '$length / $_maxChars',
                colorString: length >= _maxChars
                    ? Colors.redAccent
                    : AppColors.darkBlue.withValues(alpha: 0.45),
                fontNum: 11,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =====================================================
  // Random User Section
  // =====================================================

  Widget _buildRandomUserSection(AppLocalizations t) {
    final hasUser = _selectedUser != null;

    return Column(
      children: [
        _buildSectionTitle(
          t.randomRecipient,
          t.chooseSomeoneToReceiveYourMessage,
        ),

        const SizedBox(height: 14),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),

          child: hasUser ? _buildSelectedUserCard(t) : _buildNoUserCard(t),
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 52,
          width: double.infinity,

          child: OutlinedButton.icon(
            onPressed: () => _isFindingUser ? null : _pickRandomUser(t),

            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.darkBlue,
              side: const BorderSide(color: AppColors.gold, width: 1.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            icon: _isFindingUser
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.darkBlue,
                    ),
                  )
                : const Icon(Icons.casino_rounded, color: AppColors.darkBlue),

            label: SharedText(
              title: _isFindingUser
                  ? t.findingSomeone
                  : hasUser
                  ? t.pickAnotherUser
                  : t.pickRandomUser,
              colorString: AppColors.darkBlue,
              fontNum: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // No User Card
  // =====================================================

  Widget _buildNoUserCard(AppLocalizations t) {
    return Container(
      key: const ValueKey('no-user'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold),
      ),

      child: Column(
        children: [
          const Icon(
            Icons.person_search_rounded,
            size: 38,
            color: AppColors.darkBlue,
          ),

          const SizedBox(height: 10),

          SharedText(
            title: t.noRecipientSelected,
            colorString: AppColors.darkBlue,
            fontNum: 15,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          SharedText(
            title: t.tapBelowToFindSomeone,
            colorString: AppColors.darkBlue.withValues(alpha: 0.55),
            fontNum: 12,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Selected User Card
  // =====================================================

  Widget _buildSelectedUserCard(AppLocalizations t) {
    final username = _selectedUser!['username'] as String? ?? '';

    return Container(
      key: ValueKey(username),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.goldTrans.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldTrans,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkBlue,
            ),

            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(height: 10),

          SharedText(
            title: t.yourMessageWillBeSentTo,
            colorString: AppColors.darkBlue.withValues(alpha: 0.65),
            fontNum: 12,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          SharedText(
            title: '@$username',
            colorString: AppColors.darkBlue,
            fontNum: 18,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Section Title
  // =====================================================

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 34,
          margin: const EdgeInsets.only(top: 2, right: 10),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SharedText(
                title: title,
                colorString: AppColors.darkBlue,
                fontNum: 17,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 2),
              SharedText(
                title: subtitle,
                colorString: AppColors.darkBlue.withValues(alpha: 0.55),
                fontNum: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =====================================================
  // Send Button
  // =====================================================

  Widget _buildSendButton(AppLocalizations t) {
    return SizedBox(
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isSending
              ? const []
              : [
                  BoxShadow(
                    color: AppColors.darkBlue.withValues(alpha: 0.30),

                    blurRadius: 16,

                    offset: const Offset(0, 8),
                  ),
                ],
        ),

        child: ElevatedButton.icon(
          onPressed: () => _isSending ? null : _sendMessage(t),

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkBlue,
            disabledBackgroundColor: AppColors.darkBlue.withValues(alpha: 0.45),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.gold, width: 1.2),
            ),
          ),

          icon: _isSending
              ? const SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                )
              : const Icon(Icons.send_rounded, color: AppColors.gold),

          label: SharedText(
            title: _isSending ? t.sending : t.sendMessage,
            colorString: Colors.white,
            fontNum: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
