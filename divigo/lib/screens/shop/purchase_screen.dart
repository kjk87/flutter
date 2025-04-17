import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _formKey = GlobalKey<FormState>();

  // 사용자 정보 컨트롤러
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController detailAddressController = TextEditingController();

  // 상품 정보 및 가격
  final String productName = '상품명';
  final int productPrice = 50000;
  final int shippingFee = 3000;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    zipCodeController.dispose();
    addressController.dispose();
    detailAddressController.dispose();
    super.dispose();
  }

  void _searchZipCode() {
    // 우편번호 검색 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZipCodeSearchScreen(
          onSelected: (zipCode, address) {
            setState(() {
              zipCodeController.text = zipCode;
              addressController.text = address;
            });
          },
        ),
      ),
    );
  }

  void _purchase() {
    if (_formKey.currentState!.validate()) {
      // 구매 로직 구현
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('주문 완료'),
          content: Text('주문이 성공적으로 완료되었습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 최종 결제 금액 계산
    final int totalPrice = productPrice + shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: Text('상품 구매'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상품 정보 섹션
              Card(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '상품 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Center(child: Text('상품 이미지')),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '${productPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 구매자 정보 섹션
              Card(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '구매자 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // 이름 입력
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: '이름',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),

                      // 전화번호 입력
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: '전화번호',
                          border: OutlineInputBorder(),
                          hintText: '숫자만 입력해주세요',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '전화번호를 입력해주세요';
                          }
                          // 전화번호 형식 확인 (간단한 검증)
                          if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
                            return '올바른 전화번호 형식이 아닙니다';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 배송지 정보 섹션
              Card(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '배송지 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // 우편번호 입력
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: zipCodeController,
                              decoration: InputDecoration(
                                labelText: '우편번호',
                                border: OutlineInputBorder(),
                                enabled: false,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '우편번호를 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: _searchZipCode,
                            child: Text('우편번호 검색'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),

                      // 주소 입력
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: '주소',
                          border: OutlineInputBorder(),
                          enabled: false,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '주소를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),

                      // 상세 주소 입력
                      TextFormField(
                        controller: detailAddressController,
                        decoration: InputDecoration(
                          labelText: '상세 주소',
                          border: OutlineInputBorder(),
                          hintText: '상세 주소를 입력해주세요',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '상세 주소를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 결제 정보 섹션
              Card(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '결제 정보',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // 가격 정보 표시
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('상품 금액'),
                          Text('${productPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원'),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('배송비'),
                          Text('${shippingFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원'),
                        ],
                      ),
                      Divider(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '결제 금액',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 구매하기 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _purchase,
                  child: Text(
                    '구매하기',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 우편번호 검색 화면 (카카오 주소 API 웹뷰 사용)
class ZipCodeSearchScreen extends StatefulWidget {
  final Function(String zipCode, String address) onSelected;

  ZipCodeSearchScreen({required this.onSelected});

  @override
  _ZipCodeSearchScreenState createState() => _ZipCodeSearchScreenState();
}

class _ZipCodeSearchScreenState extends State<ZipCodeSearchScreen> {
  // 웹뷰 컨트롤러
  late final WebViewController _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..addJavaScriptChannel(
        'AddressChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // 카카오 주소 검색 API에서 선택한 주소 정보를 받아옴
          final Map<String, dynamic> address = jsonDecode(message.message);
          // 콜백 함수 호출하여 주소 정보 전달
          widget.onSelected(
            address['zonecode'] ?? '',
            address['roadAddress'] ?? address['jibunAddress'] ?? '',
          );
          // 이전 화면으로 돌아가기
          Navigator.pop(context);
        },
      )
      ..loadHtmlString('''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
          <style>
            body { margin: 0; padding: 0; }
            #container { width: 100%; height: 100vh; }
          </style>
        </head>
        <body>
          <div id="container"></div>
          <script>
            function initKakaoPostcode() {
              new daum.Postcode({
                width: '100%',
                height: '100%',
                oncomplete: function(data) {
                  window.AddressChannel.postMessage(JSON.stringify(data));
                }
              }).embed(document.getElementById('container'));
            }
            window.onload = initKakaoPostcode;
          </script>
        </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('우편번호 검색'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}