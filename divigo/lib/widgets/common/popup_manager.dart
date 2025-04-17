import 'package:divigo/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupManager {
  static const String _prefKey = 'popup_do_not_show_';

  static Future<void> showPopupIfNeeded(BuildContext context) async {
    final List<PopupItem> popups = [
      PopupItem(
        id: 'new_event_202403',
        title: '신규 이벤트 안내',
        content: '새로운 이벤트가 시작되었습니다!\n지금 바로 참여하세요.',
        imageUrl: 'assets/images/popup1.jpg',
        link: '/event/1',
      ),
      PopupItem(
        id: 'system_notice_202403',
        title: '시스템 점검 안내',
        content: '3월 15일 02:00 ~ 06:00\n서버 점검이 진행됩니다.',
        imageUrl: 'assets/images/popup2.jpg',
        link: '/notice/2',
      ),
    ];

    final prefs = await SharedPreferences.getInstance();

    for (final popup in popups) {
      final doNotShow = prefs.getBool(_prefKey + popup.id) ?? false;
      if (!doNotShow) {
        // ignore: use_build_context_synchronously
        await _showPopup(context, popup);
      }
    }
  }

  static Future<void> _showPopup(BuildContext context, PopupItem popup) async {
    return showDialog(
      context: context,
      builder: (context) => PopupDialog(popup: popup),
    );
  }
}

class PopupDialog extends StatefulWidget {
  final PopupItem popup;

  const PopupDialog({
    super.key,
    required this.popup,
  });

  @override
  State<PopupDialog> createState() => _PopupDialogState();
}

class _PopupDialogState extends State<PopupDialog> {
  bool _doNotShowAgain = false;

  Future<void> _setDoNotShowAgain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      PopupManager._prefKey + widget.popup.id,
      _doNotShowAgain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, widget.popup.link);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  widget.popup.imageUrl,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.popup.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.popup.content),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _doNotShowAgain,
                      onChanged: (value) {
                        setState(() {
                          _doNotShowAgain = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context).get('notShowAgain')),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    if (_doNotShowAgain) {
                      await _setDoNotShowAgain();
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalization.of(context).get('close')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PopupItem {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String link;

  PopupItem({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.link,
  });
}
