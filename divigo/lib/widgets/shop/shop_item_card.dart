import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/shop_item.dart';
import 'package:intl/intl.dart';

class ShopItemCard extends StatelessWidget {
  final Product item;
  final VoidCallback onTap;

  const ShopItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  // 할인율 계산
  String _calculateDiscount() {
    if (item.consumerPrice == 0 || item.price >= item.consumerPrice) return '0%';
    final discount = ((item.consumerPrice - item.price) / item.consumerPrice * 100).round();
    return '$discount%';
  }

  Widget _buildPlaceholderImage(String? image) {
    if(image == null){
      return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: AssetImage('assets/images/ic_default_product.png'),
              fit: BoxFit.cover,
            ),
          ));
    }
    return CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) =>
            Image.asset('assets/images/ic_default_product.png'),
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/ic_default_product.png'),
        imageBuilder: (context, imageProvider) =>
            Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 상품 이미지
            Expanded(
              flex: 3,
              child: _buildPlaceholderImage(item.images?[0].image),
            ),
            // 상품 정보
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 정상가 (취소선)
                    Text(
                      '${NumberFormat('#,###').format(item.consumerPrice)}원',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // 할인율과 판매가를 같은 줄에 표시
                    Row(
                      children: [
                        // 할인율
                        Text(
                          _calculateDiscount(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // 판매가
                        Text(
                          '${NumberFormat('#,###').format(item.price)}P',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
