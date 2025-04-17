import 'package:divigo/common/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:divigo/core/localization/app_localization.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  late Future<List<dynamic>> noticeList;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    noticeList = httpListWithCode(path: '/notice/list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).get('notice'),
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF333333),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: noticeList,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;

              return list.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return _buildNoticeItem(list[index]);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: list.length,
                    );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C72CB)),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalization.of(context).get('noNotice'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(Map<String, dynamic> notice) {
    final String formattedDate = _formatDate(notice['regDatetime']);
    final bool isExpanded = notice['isExpanded'] ?? false;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF6C72CB),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              notice['isExpanded'] = expanded;
            });
          },
          title: Text(
            notice['title'] ?? '',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ),
          iconColor: const Color(0xFF6C72CB),
          collapsedIconColor: const Color(0xFF999999),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 16, thickness: 1),
            _buildNoticeContent(notice['contents']),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeContent(String? content) {
    if (content == null || content.isEmpty) {
      return Text(
        AppLocalization.of(context).get('noContent'),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
          height: 1.5,
        ),
      );
    }

    return Html(
      data: content,
      style: {
        'body': Style(
          color: const Color(0xFF666666),
          fontSize: FontSize(14),
          lineHeight: const LineHeight(1.5),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'p': Style(
          margin: Margins.only(bottom: 8),
        ),
        'a': Style(
          color: const Color(0xFF6C72CB),
          textDecoration: TextDecoration.none,
        ),
        'img': Style(
          margin: Margins.only(top: 8, bottom: 8),
        ),
        'ul': Style(
          margin: Margins.only(left: 16),
        ),
        'ol': Style(
          margin: Margins.only(left: 16),
        ),
      },
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('yyyy.MM.dd').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
