import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatefulWidget {
  final String url;

  const TermsScreen({super.key, required this.url});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF333333),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: WebViewWidget(controller: controller),
        backgroundColor: Colors.white,
      ),
    );
  }
}
