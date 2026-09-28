import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/random_message_service.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_text.dart';

class NotificationsScreen extends StatefulWidget {
  final bool isArabic;

  const NotificationsScreen({super.key, required this.isArabic});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final RandomMessageService _service = RandomMessageService();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _inboxStream;
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _inboxStream = _service.getInbox();
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isArabic = widget.isArabic;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: SharedText(
          title: t.inbox,
          colorString: AppColors.darkBlue,
          fontNum: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _inboxStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint('Inbox stream error: ${snapshot.error}');
            return Center(child: Text(t.failedToLoad));
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          final now = DateTime.now();
          final docs =
              snapshot.data!.docs
                  .where((doc) => _isVisible(doc.data(), now))
                  .toList()
                ..sort((a, b) {
                  final aTime = a.data()['createdAt'];
                  final bTime = b.data()['createdAt'];
                  if (aTime is Timestamp && bTime is Timestamp) {
                    return bTime.compareTo(aTime);
                  }
                  if (aTime is Timestamp) return -1;
                  if (bTime is Timestamp) return 1;
                  return 0;
                });
          if (docs.isEmpty) {
            return Center(
              child: SharedText(
                title: t.noInboxMessages,
                colorString: Colors.white,
                fontNum: 14,
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.gold,
            onRefresh: () async => await _service.getInbox().first,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data();
                final pending =
                    data['status'] == 'pending' &&
                    data['senderId'] != data['receiverId'];
                final text = (isArabic ? data['textAr'] : data['textEn'])
                    ?.toString()
                    .trim();
                final shownText = (text?.isNotEmpty ?? false)
                    ? text!
                    : (data['message']?.toString() ?? '');
                final read = data['isRead'] == true;
                return Card(
                  color: read ? AppColors.secondaryColor : AppColors.unread,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: read ? AppColors.favBordar : AppColors.gold,
                    ),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () async {
                      await _service.markRead(doc.id);
                      if (!context.mounted) return;
                      _showDetails(context, data, shownText, isArabic, t);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                data['senderId'] == data['receiverId']
                                    ? Icons.schedule_rounded
                                    : Icons.mail_outline_rounded,
                                color: AppColors.background,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SharedText(
                                  title: data['senderId'] == data['receiverId']
                                      ? t.personalMessage
                                      : t.privateMessage,
                                  colorString: Colors.black,
                                  fontNum: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SharedText(
                                title: read ? t.read : t.newMessage,
                                fontNum: 12,
                                colorString: read
                                    ? Colors.grey
                                    : AppColors.background,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SharedText(
                            title: shownText,
                            maxLines: 3,
                            textOverflow: TextOverflow.ellipsis,
                            colorString: Colors.black,
                            fontNum: 14,
                          ),
                          if (pending) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _service.respondToMessage(
                                      doc.id,
                                      accept: false,
                                    ),
                                    child: Text(t.reject),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _service.respondToMessage(
                                      doc.id,
                                      accept: true,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.background,
                                    ),
                                    child: SharedText(
                                      title: t.accept,
                                      colorString: Colors.white,
                                      fontNum: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else if (data['status'] == 'accepted' ||
                              data['status'] == 'rejected') ...[
                            const SizedBox(height: 8),
                            SharedText(
                              title: data['status'] == 'accepted'
                                  ? t.accepted
                                  : t.rejected,
                              colorString: AppColors.background,
                              fontNum: 14,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDetails(
    BuildContext context,
    Map<String, dynamic> data,
    String message,
    bool isArabic,
    AppLocalizations t,
  ) {
    final sender = (data['senderUsername'] ?? data['senderId'] ?? '')
        .toString();
    final receiver = (data['receiverUsername'] ?? data['receiverId'] ?? '')
        .toString();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.gold, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBlue.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mark_email_read_rounded,
                        color: AppColors.background,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SharedText(
                        title: t.messageDetails,
                        colorString: AppColors.darkBlue,
                        fontNum: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _personDetail(
                  Icons.person_outline_rounded,
                  t.senderLabel,
                  sender,
                ),
                const SizedBox(height: 8),
                _personDetail(
                  Icons.person_pin_circle_outlined,
                  t.receiverLabel,
                  receiver,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SharedText(
                    title: message,
                    colorString: AppColors.darkBlue,
                    fontNum: 16,
                    maxLines: 100,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: SharedText(
                      title: t.close,
                      colorString: AppColors.darkBlue,
                      fontNum: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _personDetail(IconData icon, String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
    decoration: BoxDecoration(
      color: AppColors.primaryColor.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Icon(icon, size: 19, color: AppColors.background),
        const SizedBox(width: 9),
        SharedText(
          title: '$label: ',
          colorString: AppColors.darkBlue,
          fontNum: 14,
        ),
        Expanded(
          child: SharedText(
            title: value,
            textOverflow: TextOverflow.ellipsis,
            colorString: AppColors.darkBlue,
            fontNum: 14,
          ),
        ),
      ],
    ),
  );

  bool _isVisible(Map<String, dynamic> data, DateTime now) {
    final status = data['status']?.toString();
    if (status == 'rejected' || status == 'cancelled') return false;

    final isScheduled =
        status == 'scheduled' ||
        data['type'] == 'self_scheduled' ||
        data['scheduledAt'] != null;
    if (!isScheduled) return true;

    final rawScheduledAt = data['scheduledAt'];
    final scheduledAt = switch (rawScheduledAt) {
      Timestamp value => value.toDate(),
      DateTime value => value,
      String value => DateTime.tryParse(value),
      _ => null,
    };

    // Missing schedule data must never make a scheduled message appear early.
    return scheduledAt != null && !now.isBefore(scheduledAt);
  }
}
