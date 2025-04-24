import 'dart:developer';
import 'dart:io';

import 'package:divcow/common/components/item_back.dart';
import 'package:divcow/common/utils/admobUtil.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/data/Games.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameWebviewScreen extends StatefulWidget {
  final Games games;

  const GameWebviewScreen(this.games);

  @override
  State<GameWebviewScreen> createState() => _GameWebviewScreen();
}

class _GameWebviewScreen extends State<GameWebviewScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // 웹 페이지 로딩 진행률 업데이트
          },
          onPageStarted: (String url) {
            // 페이지 로딩 시작
          },
          onPageFinished: (String url) {
            // 페이지 로딩 완료
          },
          onWebResourceError: (WebResourceError error) {
            // 웹 리소스 로딩 중 오류 발생
          },
          onNavigationRequest: (NavigationRequest request) {
            // 특정 도메인으로의 이동을 막고 싶을 때 사용
            // if (request.url.startsWith('')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      
      ..loadRequest(Uri.parse(widget.games.url))
      ..addJavaScriptChannel(
        'AppScript',
        onMessageReceived: (JavaScriptMessage message) {
          ranking(double.parse(message.message).toInt());
          admob();
        },
      );
    
    controller.canGoBack();

    if (widget.games.orientation == 'landscape') {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
  }

  Future<void> ranking(int score) async {
    var params = {'score': score, 'games_id': widget.games.id};
    var res = await httpPost(path: '/ranking/saveApp', params: params);
    if (res != null && res['code'] == 200) {}
  }

  Future<void> admob() async {
    int milliseconds = DateTime.now().millisecondsSinceEpoch;
    const storage = FlutterSecureStorage();

    String? before = await storage.read(key: 'adViewTime');
    if (before == null || int.parse(before) + 60000 < milliseconds) {
      await storage.write(key: 'adViewTime', value: milliseconds.toString());
      AdmobUtil.instance.showInterstitialAd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: Platform.isAndroid,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            leadingWidth: 0,
            titleSpacing: 0,
            backgroundColor: DivcowColor.background,
            title: Container(
                padding:
                    const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
                child: itemBack(context, widget.games.name)),
          ),
          body: WebViewWidget(controller: controller),
          backgroundColor: DivcowColor.background,
    ));
  }
}

class TransformedMediaQuery extends StatelessWidget {
	final Widget child;
	final MediaQueryData Function(BuildContext context, MediaQueryData) transformation;

	const TransformedMediaQuery({
		required this.child,
		required this.transformation,
		super.key
	});

	@override
	Widget build(BuildContext context) {
		return MediaQuery(
			data: transformation(context, MediaQuery.of(context)),
			child: child
		);
	}
}