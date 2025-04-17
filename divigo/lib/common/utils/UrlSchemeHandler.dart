import 'package:app_links/app_links.dart';
import 'dart:async';

class UrlSchemeHandler {
  static AppLinks? _appLinks;
  static StreamController<String> _streamController = StreamController.broadcast();
  static Stream<String> get onSchemeDetected => _streamController.stream;
  static StreamSubscription? _subscription;  // URI 스트림 구독 저장
  static StreamSubscription? _listenerSubscription;  // 사용자 리스너 구독 저장

  // 초기 URL 스킴 설정
  static Future<void> initUriHandler() async {
    _appLinks = AppLinks();

    // 앱이 종료된 상태에서 URL 스킴으로 실행된 경우
    // try {
    //   final initialUri = await _appLinks?.getInitialLink();
    //   if (initialUri != null) {
    //     _handleUrl(initialUri.toString());
    //   }
    // } catch (e) {
    //   print('초기 URI 가져오기 실패: $e');
    // }

    // 기존 구독이 있다면 취소
    await _subscription?.cancel();

    // 앱이 실행 중일 때 URL 스킴 수신
    _subscription = _appLinks?.uriLinkStream.listen((uri) {
      _handleUrl(uri.toString());
    }, onError: (err) {
      print('URI 스트림 에러: $err');
    });
  }

  // URL 처리 메서드
  static void _handleUrl(String url) {
    _streamController.add(url);
  }

  // URL 스킴 리스너 등록
  static StreamSubscription listenToScheme(void Function(String) onData) {
    _listenerSubscription?.cancel();  // 기존 리스너가 있다면 취소
    _listenerSubscription = onSchemeDetected.listen(onData);
    return _listenerSubscription!;
  }

  // 리소스 해제
  static Future<void> dispose() async {
    await _subscription?.cancel();
    await _listenerSubscription?.cancel();
    await _streamController.close();
    _appLinks = null;
  }
}
