import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../services/random_message_service.dart';
import '../widgets/shared_text.dart';
import '../widgets/shared_snack_bar.dart';
import '../theme/app_colors.dart';

class ScheduleMessagePage extends StatefulWidget {
  final bool isArabic;

  const ScheduleMessagePage({super.key, required this.isArabic});

  @override
  State<ScheduleMessagePage> createState() => _ScheduleMessagePageState();
}

class _ScheduleMessagePageState extends State<ScheduleMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  final RandomMessageService _messageService = RandomMessageService();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isScheduling = false;

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
    _messageController.removeListener(_refresh);
    _messageFocus.removeListener(_refresh);
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  // =====================================================
  // Helpers
  // =====================================================

  DateTime? get _scheduledDateTime {
    if (_selectedDate == null || _selectedTime == null) {
      return null;
    }

    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  bool get _hasAnything =>
      _messageController.text.trim().isNotEmpty ||
      _selectedDate != null ||
      _selectedTime != null;

  String _getCountdownText(AppLocalizations t) {
    final dt = _scheduledDateTime;

    if (dt == null) {
      return t.pickDateAndTimeToSeeCountdown;
    }

    final diff = dt.difference(DateTime.now());

    if (diff.isNegative) {
      return t.thatMomentHasAlreadyPassed;
    }

    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();

      return '${t.arrivesIn} $years '
          '${years == 1 ? t.year : t.years}';
    }

    if (diff.inDays >= 1) {
      final days = diff.inDays;

      return '${t.arrivesIn} $days '
          '${days == 1 ? t.day : t.days}';
    }

    if (diff.inHours >= 1) {
      final hours = diff.inHours;

      return '${t.arrivesIn} $hours '
          '${hours == 1 ? t.hour : t.hours}';
    }

    return '${t.arrivesIn} ${diff.inMinutes} ${t.minutes}';
  }

  // =====================================================
  // Picker Theme
  // =====================================================

  ThemeData _pickerTheme(BuildContext context) {
    final isDark = AppColors.isDark;

    return Theme.of(context).copyWith(
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,

        primary: AppColors.darkBlue,
        onPrimary: isDark ? AppColors.darkBlueBase : Colors.white,

        secondary: AppColors.gold,
        onSecondary: AppColors.darkBlue,

        surface: AppColors.secondaryColor,
        onSurface: AppColors.darkBlue,

        error: AppColors.error,
        onError: Colors.white,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.secondaryColor,
        surfaceTintColor: Colors.transparent,
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.darkBlue),
      ),
    );
  }

  // =====================================================
  // Date / Time Picker
  // =====================================================

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(data: _pickerTheme(context), child: child!);
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: _pickerTheme(context), child: child!);
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _applyQuickPick(Duration duration) {
    final target = DateTime.now().add(duration);

    setState(() {
      _selectedDate = DateTime(target.year, target.month, target.day);

      _selectedTime ??= TimeOfDay(hour: target.hour, minute: target.minute);
    });
  }

  // =====================================================
  // Schedule Message
  // =====================================================

  Future<void> _scheduleMessage(AppLocalizations t) async {
    FocusScope.of(context).unfocus();

    final message = _messageController.text.trim();

    if (message.isEmpty) {
      SharedSnackBar.showError(
        context: context,
        message: t.writeYourMessageFirst,
      );
      return;
    }

    if (_selectedDate == null) {
      SharedSnackBar.showError(
        context: context,
        message: t.chooseTheDateItShouldArrive,
      );
      return;
    }

    if (_selectedTime == null) {
      SharedSnackBar.showError(
        context: context,
        message: t.chooseTheTimeItShouldArrive,
      );
      return;
    }

    final scheduledDateTime = _scheduledDateTime!;

    if (scheduledDateTime.isBefore(DateTime.now())) {
      SharedSnackBar.showError(
        context: context,
        message: t.thatTimeHasPassedPickALaterOne,
      );
      return;
    }

    setState(() {
      _isScheduling = true;
    });

    try {
      await _messageService.scheduleMessageToSelf(
        message: message,
        scheduledAt: scheduledDateTime,
      );

      if (!mounted) return;

      setState(() {
        _isScheduling = false;
      });

      SharedSnackBar.showSuccess(
        context: context,
        message: t.scheduledItWillReachYouOnTime,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isScheduling = false;
      });

      SharedSnackBar.showError(
        context: context,
        message: t.messageWasNotSavedTryAgain,
      );
    }
  }

  // =====================================================
  // Date Formatting
  // =====================================================

  String _getDateText(AppLocalizations t) {
    if (_selectedDate == null) {
      return t.notSet;
    }

    return '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
  }

  String _getTimeText(AppLocalizations t) {
    if (_selectedTime == null) {
      return t.notSet;
    }

    return _selectedTime!.format(context);
  }

  // =====================================================
  // Build
  // =====================================================

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

        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          icon: const Icon(Icons.arrow_back),
        ),

        title: SharedText(
          title: t.scheduleMessage,
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
            stops: const [0.0, 0.75],
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

                  _buildSectionTitle(t.yourMessage, t.onlyYouWillReadIt),

                  const SizedBox(height: 10),

                  _buildMessageField(t, isArabic),

                  const SizedBox(height: 26),

                  _buildSectionTitle(t.deliveryTime, t.pickAMomentInTheFuture),

                  const SizedBox(height: 10),

                  _buildQuickPicks(t),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectionCard(
                          icon: Icons.calendar_month_rounded,
                          title: t.date,
                          value: _getDateText(t),
                          isSet: _selectedDate != null,
                          onTap: _selectDate,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _buildSelectionCard(
                          icon: Icons.access_time_rounded,
                          title: t.time,
                          value: _getTimeText(t),
                          isSet: _selectedTime != null,
                          onTap: _selectTime,
                        ),
                      ),
                    ],
                  ),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    alignment: Alignment.topCenter,

                    child: _hasAnything
                        ? Padding(
                            padding: const EdgeInsets.only(top: 26),
                            child: _buildPreview(t),
                          )
                        : const SizedBox(width: double.infinity),
                  ),

                  const SizedBox(height: 28),

                  _buildScheduleButton(t),
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

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkBlue, AppColors.primaryColor],
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
              Icons.schedule_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          SharedText(
            title: t.aMessageForYourFutureSelf,
            colorString: Colors.white,
            fontNum: 20,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          SharedText(
            title: t.writeItNowReceiveItExactlyWhenYouChoose,
            colorString: Colors.white.withValues(alpha: 0.75),
            fontNum: 13,
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

        const SizedBox(width: 10),

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
  // Message Field
  // =====================================================

  Widget _buildMessageField(AppLocalizations t, bool isArabic) {
    final focused = _messageFocus.hasFocus;
    final length = _messageController.text.characters.length;

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
            maxLines: 7,
            minLines: 5,
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
              hintText: t.whatDoYouWantToRemember,

              hintStyle: GoogleFonts.getFont(
                isArabic ? 'Almarai' : 'Alike',
                textStyle: TextStyle(
                  color: AppColors.secondaryText,
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
                ? AppColors.error
                : AppColors.darkBlue.withValues(alpha: 0.45),
            fontNum: 11,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Quick Picks
  // =====================================================

  Widget _buildQuickPicks(AppLocalizations t) {
    final options = <String, Duration>{
      t.tomorrow: const Duration(days: 1),
      t.inAWeek: const Duration(days: 7),
      t.inAMonth: const Duration(days: 30),
      t.inAYear: const Duration(days: 365),
    };

    return SizedBox(
      height: 38,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        itemCount: options.length,

        separatorBuilder: (_, _) => const SizedBox(width: 8),

        itemBuilder: (context, index) {
          final label = options.keys.elementAt(index);
          final duration = options.values.elementAt(index);

          final target = DateTime.now().add(duration);

          final isActive =
              _selectedDate != null &&
              _selectedDate!.year == target.year &&
              _selectedDate!.month == target.month &&
              _selectedDate!.day == target.day;

          return InkWell(
            onTap: () {
              _applyQuickPick(duration);
            },

            borderRadius: BorderRadius.circular(30),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),

              padding: const EdgeInsets.symmetric(horizontal: 16),

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.darkBlue.withValues(alpha: 0.90)
                    : AppColors.secondaryColor,

                borderRadius: BorderRadius.circular(30),

                border: Border.all(
                  color: isActive ? AppColors.gold : AppColors.darkBlue,
                ),
              ),

              child: SharedText(
                title: label,

                colorString: isActive ? AppColors.gold : AppColors.darkBlue,

                fontNum: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  // =====================================================
  // Selection Card
  // =====================================================

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isSet,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(18),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: isSet
              ? AppColors.goldTrans.withValues(alpha: 0.30)
              : AppColors.secondaryColor,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: AppColors.gold, width: isSet ? 1.5 : 1.0),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.darkBlue, size: 20),

                const SizedBox(width: 7),

                Expanded(
                  child: SharedText(
                    title: title,
                    colorString: AppColors.darkBlue,
                    fontNum: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Icon(
                  Icons.expand_more_rounded,
                  size: 18,
                  color: AppColors.darkBlue.withValues(alpha: 0.5),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SharedText(
              title: value,
              colorString: isSet
                  ? AppColors.darkBlue
                  : AppColors.darkBlue.withValues(alpha: 0.4),
              fontNum: 15,
              fontWeight: isSet ? FontWeight.bold : FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Preview
  // =====================================================

  Widget _buildPreview(AppLocalizations t) {
    final message = _messageController.text.trim();

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.secondaryColor,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: AppColors.gold),

        boxShadow: [
          BoxShadow(
            color: AppColors.goldTrans,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.mark_email_unread_outlined,
                color: AppColors.darkBlue,
                size: 19,
              ),

              const SizedBox(width: 7),

              SharedText(
                title: t.preview,
                colorString: AppColors.darkBlue,
                fontNum: 15,
                fontWeight: FontWeight.bold,
              ),

              const Spacer(),

              SharedText(
                title: '${_getDateText(t)}  ·  ${_getTimeText(t)}',
                colorString: AppColors.darkBlue.withValues(alpha: 0.6),
                fontNum: 12,
                fontWeight: FontWeight.w600,
                textOverflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Message bubble
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppColors.primaryColor,

              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),

            child: SharedText(
              title: message.isEmpty ? t.yourMessageWillAppearHere : message,

              colorString: message.isEmpty
                  ? AppColors.darkBlue.withValues(alpha: 0.4)
                  : AppColors.darkBlue,

              fontNum: 14,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Icon(
                Icons.hourglass_bottom_rounded,
                size: 17,
                color: AppColors.darkBlue,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: SharedText(
                  title: _getCountdownText(t),
                  colorString: AppColors.darkBlue,
                  fontNum: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Schedule Button
  // =====================================================

  Widget _buildScheduleButton(AppLocalizations t) {
    return SizedBox(
      height: 54,

      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          boxShadow: _isScheduling
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
          onPressed: () => _isScheduling ? null : _scheduleMessage(t),

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkBlue,

            disabledBackgroundColor: AppColors.darkBlue.withValues(alpha: 0.45),

            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),

              side: BorderSide(color: AppColors.gold, width: 1.2),
            ),
          ),

          icon: _isScheduling
              ? SizedBox(
                  width: 19,
                  height: 19,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.gold,
                  ),
                )
              : Icon(Icons.schedule_send_rounded, color: AppColors.gold, size: 25),

          label: SharedText(
            title: _isScheduling ? t.scheduling : t.scheduleMessageButton,
            colorString: AppColors.primaryColor,
            fontNum: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
