import 'package:flutter/material.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuGroup(
            title: '고객센터',
            items: [
              MenuItem(
                icon: Icons.announcement_outlined,
                title: '공지사항',
                route: '/more/notice',
              ),
              MenuItem(
                icon: Icons.help_outline,
                title: 'FAQ',
                route: '/more/faq',
              ),
              MenuItem(
                icon: Icons.question_answer_outlined,
                title: '문의하기',
                route: '/more/inquiry',
              ),
            ],
          ),
          const Divider(height: 1),
          _buildMenuGroup(
            title: '앱 정보',
            items: [
              MenuItem(
                icon: Icons.info_outline,
                title: '버전 정보',
                route: '/more/version',
                trailing: Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              MenuItem(
                icon: Icons.description_outlined,
                title: '이용약관',
                route: '/more/terms',
              ),
              MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: '개인정보처리방침',
                route: '/more/privacy',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup({
    required String title,
    required List<MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(item)),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      trailing: item.trailing ?? const Icon(Icons.chevron_right),
      onTap: () {
        // 네비게이션 처리
      },
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final String route;
  final Widget? trailing;

  MenuItem({
    required this.icon,
    required this.title,
    required this.route,
    this.trailing,
  });
}
