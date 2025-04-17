import 'dart:developer';

import 'package:divigo/common/components/item_back.dart';
import 'package:divigo/common/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BannerWebviewScreen extends StatefulWidget {
  final String url;
  final String title;

  const BannerWebviewScreen(this.title, this.url, {super.key});

  @override
  State<BannerWebviewScreen> createState() => _BannerWebviewScreen();
}

class _BannerWebviewScreen extends State<BannerWebviewScreen> {
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
      ..loadRequest(Uri.parse(widget.url));
    controller.canGoBack();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 0,
        titleSpacing: 0,
        backgroundColor: DivigoColor.background,
        title: Container(
            padding: const EdgeInsets.only(
                left: 10, top: 20, right: 10, bottom: 10),
            child: itemBack(context, widget.title)
        ),
      ),
      body: WebViewWidget(controller: controller),
      backgroundColor: DivigoColor.background,
    );
  }
}
