import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late Future<List<dynamic>> faqList;
  late Future<List<dynamic>> faqCategoryList;
  late dynamic category = null;

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  _fetchFaq() {
    faqList = httpListWithCode(path: '/faq/list?category=$category');
  }

  _fetchCategory() {
    faqCategoryList = httpListWithCode(path: '/faq/category/list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQ\'S',
          style: TextStyle(
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
          future: faqCategoryList,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;

              if (category == null && list.isNotEmpty) {
                category = list[0]['seqNo'];
                _fetchFaq();
              }

              return Column(
                children: [
                  // 카테고리 탭
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final isSelected = category == list[index]['seqNo'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              category = list[index]['seqNo'];
                              _fetchFaq();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(right: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected
                                      ? const Color(0xFF6C72CB)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              list[index]['name'],
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF6C72CB)
                                    : const Color(0xFF666666),
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: list.length,
                    ),
                  ),

                  // FAQ 목록
                  Expanded(
                    child: FutureBuilder(
                      future: faqList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> list = snapshot.data!;

                          return list.isEmpty
                              ? Center(
                                  child: Text(
                                    AppLocalization.of(context).get('noFaq'),
                                    style: const TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemBuilder: (context, index) {
                                    return _buildFaqItem(
                                      title: list[index]['title'],
                                      content: list[index]['contents'],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 8),
                                  itemCount: list.length,
                                );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF6C72CB)),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
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

  Widget _buildFaqItem({required String title, required String content}) {
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
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          iconColor: const Color(0xFF6C72CB),
          collapsedIconColor: const Color(0xFF999999),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 16, thickness: 1),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
