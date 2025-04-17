import 'dart:developer';

class ProductOption {
  int seqNo;
  int productSeqNo;
  String name;
  String item;
  List<ProductOptionItem> items;

  ProductOption({
    required this.seqNo,
    required this.productSeqNo,
    required this.name,
    required this.item,
    required this.items,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<ProductOptionItem> parsedItems = itemsList
        .map((item) => ProductOptionItem.fromJson(item as Map<String, dynamic>))
        .toList();
    return ProductOption(
      seqNo: json['seqNo'] as int,
      productSeqNo: json['productSeqNo'] as int,
      name: json['name'] as String,
      item: json['item'] as String,
      items: parsedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seqNo': seqNo,
      'productSeqNo': productSeqNo,
      'name': name,
      'item': item,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  ProductOption copyWith({
    int? seqNo,
    int? productSeqNo,
    String? name,
    String? item,
    List<ProductOptionItem>? items,
  }) {
    return ProductOption(
      seqNo: seqNo ?? this.seqNo,
      productSeqNo: productSeqNo ?? this.productSeqNo,
      name: name ?? this.name,
      item: item ?? this.item,
      items: items ?? this.items,
    );
  }
}

class ProductOptionItem {
  final int? seqNo;
  final int? productSeqNo;
  final int? optionSeqNo;
  final String? item;

  ProductOptionItem({
    this.seqNo,
    this.productSeqNo,
    this.optionSeqNo,
    this.item,
  });

  factory ProductOptionItem.fromJson(Map<String, dynamic> json) {
    log('json $json');
    return ProductOptionItem(
      seqNo: json['seqNo'] as int?,
      productSeqNo: json['productSeqNo'] as int?,
      optionSeqNo: json['optionSeqNo'] as int?,
      item: json['item'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seqNo': seqNo,
      'productSeqNo': productSeqNo,
      'optionSeqNo': optionSeqNo,
      'item': item,
    };
  }

  ProductOptionItem copyWith({
    int? seqNo,
    int? productSeqNo,
    int? optionSeqNo,
    String? item,
  }) {
    return ProductOptionItem(
      seqNo: seqNo ?? this.seqNo,
      productSeqNo: productSeqNo ?? this.productSeqNo,
      optionSeqNo: optionSeqNo ?? this.optionSeqNo,
      item: item ?? this.item,
    );
  }
}

class ProductOptionDetail {
  final int seqNo;
  final int productSeqNo;
  final int optionSeqNo;
  final int? depth1ItemSeqNo;
  final int? depth2ItemSeqNo;
  final int? amount;
  final int? soldCount;
  final int? price;
  final bool? flag;
  final int? status;
  final bool? usable;
  final ProductOptionItem? item1;
  final ProductOptionItem? item2;

  ProductOptionDetail({
    required this.seqNo,
    required this.productSeqNo,
    required this.optionSeqNo,
    this.depth1ItemSeqNo,
    this.depth2ItemSeqNo,
    this.amount,
    this.soldCount,
    this.price,
    this.flag,
    this.status,
    this.usable,
    this.item1,
    this.item2,
  });

  factory ProductOptionDetail.fromJson(Map<String, dynamic> json) {
    return ProductOptionDetail(
      seqNo: json['seqNo'] as int,
      productSeqNo: json['productSeqNo'] as int,
      optionSeqNo: json['optionSeqNo'] as int,
      depth1ItemSeqNo: json['depth1ItemSeqNo'] as int?,
      depth2ItemSeqNo: json['depth2ItemSeqNo'] as int?,
      amount: json['amount'] as int?,
      soldCount: json['soldCount'] as int?,
      price: json['price'] as int?,
      flag: json['flag'] as bool?,
      status: json['status'] as int?,
      usable: json['usable'] as bool?,
      item1: json['item1'] != null ? ProductOptionItem.fromJson(json['item1'] as Map<String, dynamic>) : null,
      item2: json['item2'] != null ? ProductOptionItem.fromJson(json['item2'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seqNo': seqNo,
      'productSeqNo': productSeqNo,
      'optionSeqNo': optionSeqNo,
      'depth1ItemSeqNo': depth1ItemSeqNo,
      'depth2ItemSeqNo': depth2ItemSeqNo,
      'amount': amount,
      'soldCount': soldCount,
      'price': price,
      'flag': flag,
      'status': status,
      'usable': usable,
      'item1': item1?.toJson(),
      'item2': item2?.toJson(),
    };
  }

  ProductOptionDetail copyWith({
    int? seqNo,
    int? productSeqNo,
    int? optionSeqNo,
    int? depth1ItemSeqNo,
    int? depth2ItemSeqNo,
    int? amount,
    int? soldCount,
    int? price,
    bool? flag,
    int? status,
    bool? usable,
    ProductOptionItem? item1,
    ProductOptionItem? item2,
  }) {
    return ProductOptionDetail(
      seqNo: seqNo ?? this.seqNo,
      productSeqNo: productSeqNo ?? this.productSeqNo,
      optionSeqNo: optionSeqNo ?? this.optionSeqNo,
      depth1ItemSeqNo: depth1ItemSeqNo ?? this.depth1ItemSeqNo,
      depth2ItemSeqNo: depth2ItemSeqNo ?? this.depth2ItemSeqNo,
      amount: amount ?? this.amount,
      soldCount: soldCount ?? this.soldCount,
      price: price ?? this.price,
      flag: flag ?? this.flag,
      status: status ?? this.status,
      usable: usable ?? this.usable,
      item1: item1 ?? this.item1,
      item2: item2 ?? this.item2,
    );
  }
}