import 'package:divigo/core/localization/app_localization.dart';
import 'package:divigo/screens/lottery/scratch_lottery_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../common/utils/http.dart';

class EventDetailScreen extends StatefulWidget {
  final String number;

  const EventDetailScreen({required this.number, Key? key}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = false;

  // 복권받기 버튼 클릭 시 실행되는 함수
  void _onPressLotteryButton() async {
    // 로딩 시작
    setState(() {
      _isLoading = true;
    });

    try {
      // 여기에 API 호출 로직을 구현하세요
      var params = {
        'category': 'event',
        'type': 'charge',
        'count': 1,
        'subject': '${widget.number} event',
        'comment': '${widget.number} event',
      };

      var res = await httpPost(path: '/member/updateLotteryCount', params: params);
      // 완료 후 메시지 표시 (실제 구현 시 API 호출 결과에 따라 수정)
      if (!mounted) return;
      if(res['code'] == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalization.of(context).get('gameGetLottery'))),
        );

        final String? url;
        if(widget.number == '1515'){
          url = 'https://shopee.com.my/m/welcome-series';
        }else if(widget.number == '7777'){
          url = 'https://www.fn.com.my/promotion_contest/peraduan-fn-nikmat-dikongsi-kenangan-abadi/';
        }else{
          url = null;
        }


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            ScratchLotteryScreen(redirectUrl: url),
          ),
        );
      }
    } catch (e) {
      // 오류 처리
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.of(context).get('networkError'))),
      );
    } finally {
      // 로딩 종료
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 예시 이미지 URL 리스트
    final List<String> imageUrls = [
      'https://cdn.prnumber.com/div/event/${widget.number}_detail.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.number} Event'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 상단 이미지 리스트 (width 100%)
              Expanded(
                child: ListView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity, // width 100%
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // 로딩 인디케이터 (로딩 중일 때만 표시)
          if (_isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      // 하단 고정 버튼
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _onPressLotteryButton,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            // 로딩 중일 때 버튼 비활성화
            disabledBackgroundColor: Colors.orange.withOpacity(0.6),
          ),
          child: Text(
            _isLoading ? AppLocalization.of(context).get('loading') : AppLocalization.of(context).get('receiveLottery'),
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}