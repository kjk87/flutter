import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:divigo/common/components/format.dart';
import 'package:divigo/common/utils/http.dart';
import 'package:divigo/models/product_option.dart';
import 'package:divigo/screens/shop/product_option_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/localization/app_localization.dart';
import '../../models/shop_item.dart';
import 'package:intl/intl.dart';

class ShopDetailScreen extends StatefulWidget {
  final int seqNo;

  const ShopDetailScreen({
    Key? key,
    required this.seqNo,
  }) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final PageController _pageController = PageController();
  late Future<Product> futureItem;
  List<ProductOption>? optionList;
  List<ProductOptionDetail>? optionDetailList;

  @override
  void initState() {
    super.initState();
    futureItem = fetchShopItem(widget.seqNo);
  }

  Future<Product> fetchShopItem(int seqNo) async {
    try {
      final path = '/product/${widget.seqNo}';
      final data = await httpGetWithCode(path: path);

      return Product.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching item: $e');
    }
  }

  Future fetchProductOption(int seqNo) async {
    try {
      final path = '/productOption';
      final Map<String, dynamic> params = {
        'productSeqNo': 1,
      };
      final data = await httpGetWithCode(path: path, queryParameters: params);
      optionList =  (data['option'] as List).map((json) => ProductOption.fromJson(json as Map<String, dynamic>)).toList();
      optionDetailList =  (data['detail'] as List).map((json) => ProductOptionDetail.fromJson(json as Map<String, dynamic>)).toList();
      log('detail ${optionDetailList}');
    } catch (e) {
      throw Exception('Error fetching item: $e');
    }
  }

  String _calculateDiscount(Product item) {
    if (item.consumerPrice == 0 || item.price >= item.consumerPrice) {
      return '0%';
    }
    final discount = ((item.consumerPrice - item.price) / item.consumerPrice * 100).round();
    return '$discount%';
  }

  Widget _buildImageSlider(Product item) {
    if (item.images == null || item.images!.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {});
            },
            itemCount: item.images!.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: item.images![index].image ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset('assets/images/ic_default_product.png'),
                errorWidget: (context, url, error) => Image.asset('assets/images/ic_default_product.png'),
              );
            },
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: item.images!.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                type: WormType.thin,
                strokeWidth: 1,
                dotColor: Colors.grey[300]!,
                activeDotColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(Product item) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSlider(item),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalization.of(context).get('originPrice').replaceAll('%s', numberFormat(item.consumerPrice)),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _calculateDiscount(item),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${numberFormat(item.price)}P',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Html(
                  data: item.contents,
                  style: {
                    "body": Style(
                      fontSize: FontSize(14),
                      lineHeight: LineHeight(1.6),
                    ),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.get('productDetail')),
      ),
      body: FutureBuilder<Product>(
        future: futureItem,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureItem = fetchShopItem(widget.seqNo);
                      });
                    },
                    child: Text(local.get('retry')),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(local.get('notFoundProduct')),
            );
          }

          if(snapshot.data!.useOption != null && snapshot.data!.useOption!){
            fetchProductOption(widget.seqNo);
          }

          return _buildContent(snapshot.data!);
        },
      ),
      bottomNavigationBar: FutureBuilder<Product>(
        future: futureItem,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              top: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent, // 배경색 투명으로 변경
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // TODO: 구매 로직 구현

                if(snapshot.data!.useOption != null && snapshot.data!.useOption! && optionList != null && optionList!.isNotEmpty){
                  showProductOptionSheet(context, snapshot.data!);
                }else{
                  showProductPurchaseSheet(context, snapshot.data!.name);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                local.get('purchase'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showProductPurchaseSheet(BuildContext context, String productName) {
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 핸들바
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // 상품명
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // 수량 선택
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalization.of(context).get('productCount'),
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--;
                            });
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                // 구매하기 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // 구매 로직 구현
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      AppLocalization.of(context).get('purchase'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 사용 방법
  void showProductOptionSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ProductOptionSheet(
        product: product,
        options: optionList!,
        optionDetails: optionDetailList!,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}