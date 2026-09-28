import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../services/random_message_service.dart';
import '../widgets/shared_text.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_snack_bar.dart';

class RandomMessagePage extends StatefulWidget {
  final bool isArabic;
  const RandomMessagePage({super.key, required this.isArabic});

  @override
  State<RandomMessagePage> createState() => _RandomMessagePageState();
}

class _RandomMessagePageState extends State<RandomMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  final RandomMessageService _messageService = RandomMessageService();
  bool _isSending = false;
  static const int _maxChars = 500;

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
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------
  // Send message
  // ---------------------------------------------------------

  Future<void> _sendMessage(AppLocalizations t) async {
    FocusScope.of(context).unfocus();
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      SharedSnackBar.showError(context: context, message: t.writeMessageFirst);
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // The system chooses the delivery time.
      // The user never sees this value.
      await _messageService.scheduleMessageToSelfAtRandomTime(
        message: message,
        minimumDelay: const Duration(days: 30),
        maximumDelay: const Duration(days: 365),
      );

      if (!mounted) return;
      setState(() {
        _isSending = false;
      });

      _messageController.clear();
      SharedSnackBar.showSuccess(
        context: context,
        message: t.messageSentSuccess,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
      });

      SharedSnackBar.showError(context: context, message: t.messageNotSaved);
    }
  }

  // ---------------------------------------------------------
  // Build
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bool isArabic = widget.isArabic;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: SharedText(
          title: t.randomMessage,
          colorString: AppColors.darkBlue,
          fontNum: 20,
          fontWeight: FontWeight.bold,
        ),

        iconTheme: IconThemeData(color: AppColors.darkBlue),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColor, AppColors.secondaryColor],
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
                  const SizedBox(height: 28),
                  _buildSectionTitle(
                    t.yourMessage,
                    t.writeSomethingForFutureSelf,
                  ),
                  const SizedBox(height: 10),
                  _buildMessageField(t, isArabic),
                  const SizedBox(height: 30),
                  _buildInfoCard(t),
                  const SizedBox(height: 30),
                  _buildSendButton(t),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Header
  // ---------------------------------------------------------

  Widget _buildHeader(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
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
              Icons.auto_awesome_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          SharedText(
            title: t.surpriseForFutureSelf,
            colorString: Colors.white,
            fontNum: 20,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),
          SharedText(
            title: t.randomMessageDescription,
            textAlign: TextAlign.center,
            colorString: Colors.white.withValues(alpha: 0.75),
            fontNum: 13,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Section title
  // ---------------------------------------------------------

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

  // ---------------------------------------------------------
  // Message field
  // ---------------------------------------------------------

  Widget _buildMessageField(AppLocalizations t, bool isArabic) {
    final focused = _messageFocus.hasFocus;
    final length = _messageController.text.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
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
            maxLines: 8,
            minLines: 6,
            maxLength: _maxChars,
            textInputAction: TextInputAction.newline,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: AppColors.darkBlue,
            style: GoogleFonts.getFont(
              isArabic ? 'Almarai' : 'Alike',
              textStyle: TextStyle(color: AppColors.darkBlue, fontSize: 15),
            ),

            decoration: InputDecoration(
              counterText: '',
              hintText: t.messageHint,
              hintStyle: GoogleFonts.getFont(
                isArabic ? 'Almarai' : 'Alike',
                textStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),

          SharedText(
            title: '$length / $_maxChars',
            fontNum: 11,
            colorString: length >= _maxChars
                ? Colors.redAccent
                : AppColors.darkBlue.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Information card
  // ---------------------------------------------------------

  Widget _buildInfoCard(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.8)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_clock_rounded,
              color: AppColors.darkBlue,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SharedText(
                  title: t.surpriseIsWaiting,
                  colorString: AppColors.darkBlue,
                  fontNum: 14,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                SharedText(
                  title: t.deliveryTimeDescription,
                  colorString: AppColors.darkBlue.withValues(alpha: 0.60),
                  fontNum: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Send button
  // ---------------------------------------------------------

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
              side: BorderSide(color: AppColors.gold, width: 1.2),
            ),
          ),

          icon: _isSending
              ? SizedBox(
                  width: 19,
                  height: 19,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                )
              : Icon(Icons.send_rounded, color: AppColors.gold),
          label: SharedText(
            title: _isSending ? t.sending : t.sendToTheFuture,
            fontNum: 16,
            fontWeight: FontWeight.bold,
            colorString: Colors.white,
          ),
        ),
      ),
    );
  }
}
