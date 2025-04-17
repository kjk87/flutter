import 'dart:ffi';

class Product {
  final int seqNo;
  final String? marketType;
  final int? salesType;
  final int? status;
  final bool? blind;
  final String? reason;
  final int? first;
  final int? second;
  final int? third;
  final String name;
  final String? priceMethod;
  final bool? surtax;
  final bool? salesTerm;
  final String? startDate;
  final String? endDate;
  final String contents;
  final int? count;
  final int? soldCount;
  final bool? useOption;
  final String? optionType;
  final String? optionArray;
  final String? register;
  final String? registerType;
  final bool? isKc;
  final String? nonKcMemo;
  final String? noticeGroup;
  final String? regDatetime;
  final String? modDatetime;
  final String? statusDatetime;
  final String? wholesaleCompany;
  final String? originalSeqNo;
  final int? supplierSeqNo;
  final String? origin;
  final String? notice;
  final String? subName;
  final String? domeSellerId;
  final bool? changeEnable;
  final int? supplyPrice;
  final int consumerPrice;
  final int price;
  final int? deliveryType;
  final double? deliveryFee;
  final String? effectiveDate;
  final List<ProductImage>? images;

  Product({
    required this.seqNo,
    this.marketType,
    this.salesType,
    this.status,
    this.blind,
    this.reason,
    this.first,
    this.second,
    this.third,
    required this.name,
    this.priceMethod,
    this.surtax,
    this.salesTerm,
    this.startDate,
    this.endDate,
    required this.contents,
    this.count,
    this.soldCount,
    this.useOption,
    this.optionType,
    this.optionArray,
    this.register,
    this.registerType,
    this.isKc,
    this.nonKcMemo,
    this.noticeGroup,
    this.regDatetime,
    this.modDatetime,
    this.statusDatetime,
    this.wholesaleCompany,
    this.originalSeqNo,
    this.supplierSeqNo,
    this.origin,
    this.notice,
    this.subName,
    this.domeSellerId,
    this.changeEnable,
    this.supplyPrice,
    required this.consumerPrice,
    required this.price,
    this.deliveryType,
    this.deliveryFee,
    this.effectiveDate,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      seqNo: json['seqNo'] as int,
      marketType: json['marketType'] as String?,
      salesType: json['salesType'] as int?,
      status: json['status'] as int?,
      blind: json['blind'] as bool?,
      reason: json['reason'] as String?,
      first: json['first'] as int?,
      second: json['second'] as int?,
      third: json['third'] as int?,
      name: json['name'] as String,
      priceMethod: json['priceMethod'] as String?,
      surtax: json['surtax'] as bool?,
      salesTerm: json['salesTerm'] as bool?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      contents: json['contents'] as String,
      count: json['count'] as int?,
      soldCount: json['soldCount'] as int?,
      useOption: json['useOption'] as bool?,
      optionType: json['optionType'] as String?,
      optionArray: json['optionArray'] as String?,
      register: json['register'] as String?,
      registerType: json['registerType'] as String?,
      isKc: json['isKc'] as bool?,
      nonKcMemo: json['nonKcMemo'] as String?,
      noticeGroup: json['noticeGroup'] as String?,
      regDatetime: json['regDatetime'] as String?,
      modDatetime: json['modDatetime'] as String?,
      statusDatetime: json['statusDatetime'] as String?,
      wholesaleCompany: json['wholesaleCompany'] as String?,
      originalSeqNo: json['originalSeqNo'] as String?,
      supplierSeqNo: json['supplierSeqNo'] as int?,
      origin: json['origin'] as String?,
      notice: json['notice'] as String?,
      subName: json['subName'] as String?,
      domeSellerId: json['domeSellerId'] as String?,
      changeEnable: json['changeEnable'] as bool?,
      supplyPrice: json['supplyPrice'] as int?,
      consumerPrice: json['consumerPrice'] as int,
      price: json['price'] as int,
      deliveryType: json['deliveryType'] as int?,
      deliveryFee: json['deliveryFee']?.toDouble(),
      effectiveDate: json['effectiveDate'] as String?,
      images: (json['images'] as List?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductImage {
  final int seqNo;
  final int productSeqNo;
  final String image;
  final int? array;
  final bool? deligate;

  ProductImage({
    required this.seqNo,
    required this.productSeqNo,
    required this.image,
    this.array,
    this.deligate,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      seqNo: json['seqNo'] as int,
      productSeqNo: json['productSeqNo'] as int,
      image: json['image'] as String,
      array: json['array'] as int?,
      deligate: json['deligate'] as bool?,
    );
  }
}