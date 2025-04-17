import 'dart:developer';

import 'package:divigo/common/components/format.dart';
import 'package:divigo/common/utils/loginInfo.dart';
import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/models/member.dart';
import 'package:flutter/material.dart';

import '../../common/utils/http.dart';
import '../../models/history_point.dart';

class PointHistoryScreen extends StatefulWidget {
  const PointHistoryScreen({super.key});

  @override
  State<PointHistoryScreen> createState() => _PointHistoryScreenState();
}

class _PointHistoryScreenState extends State<PointHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<HistoryPoint> _pointHistories = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _fetchPointHistory();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchPointHistory();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPointHistory() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // API 호출을 시뮬레이션하기 위한 딜레이
      final Map<String, dynamic> params = {
        'paging[page]': _currentPage,
        'paging[limit]': _itemsPerPage
      };

      final result = await httpGetWithCode(
          path: '/history/point/list', queryParameters: params);
      final List<HistoryPoint> newItems = (result['list'] as List)
          .map((json) => HistoryPoint.fromJson(json as Map<String, dynamic>))
          .toList();
      final total = result['total'];

      setState(() {
        _pointHistories.addAll(newItems);
        _currentPage++;
        _isLoading = false;

        // 테스트를 위해 50개 이상의 아이템이 로드되면 더 이상 로드하지 않도록 설정
        if (_pointHistories.length >= total) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // 에러 처리
      debugPrint('Error fetching point history: $e');
    }
  }

  Future<void> _refreshPointHistory() async {
    setState(() {
      _pointHistories.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchPointHistory();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.get('pointHistory')),
      ),
      body: Column(
        children: [
          FutureBuilder<Member?>(
            future: getUser(context), // 포인트를 가져오는 비동기 함수
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          local.get('pointBalance'),
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        else if (snapshot.hasError)
                          Text(
                            '로딩 실패',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                            ),
                          )
                        else
                          Text(
                            '${numberFormat(snapshot.data!.point)} P',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/more/points/exchange');
                      },
                      child: Text(local.get('pointExchange')),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPointHistory,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _pointHistories.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _pointHistories.length) {
                    final item = _pointHistories[index];
                    final bool isEarned =
                        (item.type == 'charge' || item.type == 'provide');

                    return ListTile(
                      title: Text(item.subject),
                      subtitle: Text(
                        item.regDatetime,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        '${isEarned ? '+' : '-'}${item.point.toString()} P',
                        style: TextStyle(
                          color: isEarned ? Colors.blue : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    // 로딩 인디케이터
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
