import 'package:divigo/screens/shop/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../common/utils/http.dart';
import '../../core/localization/app_localization.dart';
import '../../models/shop_item.dart';
import '../../widgets/shop/shop_item_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<List<Product>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = fetchShopItems();
  }

  Future<List<Product>> fetchShopItems() async {
    final Map<String, dynamic> params = {
      'paging[page]': 1,
      'paging[limit]': 30
    };

    final list = await httpListWithCode(path: '/product', queryParameters: params);
    return list.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(local.get('shopItems')),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureItems,
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
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(local.get('noItems')),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => ShopItemCard(
              item: snapshot.data![index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ShopDetailScreen(seqNo: snapshot.data![index].seqNo,),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
