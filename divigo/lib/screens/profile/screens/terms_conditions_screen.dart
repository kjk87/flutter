import 'package:divigo/common/utils/http.dart';
import 'package:divigo/screens/signin/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:divigo/core/localization/app_localization.dart';

class ProfileTermsScreen extends StatefulWidget {
  const ProfileTermsScreen({super.key});

  @override
  State<ProfileTermsScreen> createState() => _ProfileTermsScreenState();
}

class _ProfileTermsScreenState extends State<ProfileTermsScreen> {
  Future<List<dynamic>> termsList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() {
    setState(() {
      termsList = httpListWithCode(path: '/terms');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context).get('termsOfService'),
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
          future: termsList,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list = snapshot.data!;

              return list.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        return _buildTermsItem(list[index]);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
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
            Icons.description_outlined,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalization.of(context).get('noTerms'),
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

  Widget _buildTermsItem(Map<String, dynamic> terms) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return TermsScreen(url: terms['url']);
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.article_outlined,
                color: Color(0xFF6C72CB),
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  terms['title'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFCCCCCC),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
