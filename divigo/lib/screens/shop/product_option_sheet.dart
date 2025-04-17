import 'package:divigo/common/components/toast.dart';
import 'package:divigo/screens/shop/purchase_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/localization/app_localization.dart';
import '../../models/product_option.dart';
import '../../models/shop_item.dart';

class ProductOptionSheet extends StatefulWidget {
  final Product product;
  final List<ProductOption> options;
  final List<ProductOptionDetail> optionDetails;

  const ProductOptionSheet({
    Key? key,
    required this.product,
    required this.options,
    required this.optionDetails,
  }) : super(key: key);

  @override
  State<ProductOptionSheet> createState() => _ProductOptionSheetState();
}

class _ProductOptionSheetState extends State<ProductOptionSheet> {
  List<SelectedOption> selectedOptions = [];
  List<ProductOptionItem> selectedOptionItems = [];
  Map<int, bool> expandedOptions = {};

  @override
  Widget build(BuildContext context) {
    final local = AppLocalization.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.8,
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
            widget.product.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // 옵션 선택 영역
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  selectedOptionItems.add(ProductOptionItem());
                  bool isExpanded = expandedOptions[option.seqNo] ?? false;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 옵션 버튼
                      InkWell(
                        onTap: () {
                          setState(() {
                            if(widget.product.optionType == 'union'){
                              if (index != 0 && selectedOptionItems[index - 1].seqNo == null) {
                                toast(local.get('selectBeforeOption'));
                                return;
                              }
                            }
                            expandedOptions[option.seqNo] = !isExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 아이템 목록 (확장 시에만 표시)
                      if (isExpanded) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: index == widget.options.length - 1
                                ? widget.optionDetails.where((detail) {
                              // 이전 옵션들이 선택되어 있는지 확인
                              if (selectedOptions.length < widget.options.length - 1) return false;

                              if(widget.product.optionType == 'union'){
                                if(widget.options.length == 1){
                                  return true;
                                }else if(widget.options.length == 2){
                                  return detail.depth1ItemSeqNo == selectedOptionItems[0].seqNo;
                                }else {
                                  return detail.depth1ItemSeqNo == selectedOptionItems[0].seqNo && detail.depth2ItemSeqNo == selectedOptionItems[1].seqNo;
                                }
                              }else {
                                return detail.optionSeqNo == option.seqNo;
                              }

                            }).map((detail) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    // 같은 옵션의 이전 선택값이 있으면 제거
                                    selectedOptions.removeWhere((selected) =>
                                      selected.detail.seqNo == detail.seqNo
                                    );

                                    String name = detail.item1!.item!;
                                    if(detail.item2 != null){
                                      name += ' / ${detail.item2!.item!}';
                                    }
                                    if(detail.price != null && detail.price! > 0){
                                      name +=' / +${detail.price}';
                                    }

                                    // 현재 선택 추가
                                    selectedOptions.add(
                                      SelectedOption(
                                        optionName: option.name,
                                        itemName: name,
                                        detail: detail,
                                        quantity: 1,
                                      ),
                                    );
                                    expandedOptions[option.seqNo] = false;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(detail.item2 != null ? '${detail.item2!.item!} +${detail.price}' : '${detail.item1!.item!} +${detail.price}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (detail.amount! > 0)
                                            Text(
                                              '재고: ${detail.amount}개',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            )
                                          else
                                            const Text(
                                              '품절',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (detail.amount! > 0)
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.grey[400],
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList()
                                : option.items.map((item) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOptionItems[index] = item;
                                    expandedOptions[option.seqNo] = false;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Text(item.item!),
                                ),
                              );
                            }).toList(),

                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          // 선택된 옵션 목록
          if (selectedOptions.isNotEmpty) ...[
            const Divider(height: 1),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedOptions.length,
                itemBuilder: (context, index) {
                  final option = selectedOptions[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.optionName,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.itemName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (option.quantity > 1) {
                                    option.quantity--;
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                              iconSize: 20,
                            ),
                            Text(
                              option.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  option.quantity++;
                                });
                              },
                              icon: const Icon(Icons.add_circle_outline),
                              iconSize: 20,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedOptions.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.close),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],

          // 구매하기 버튼
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // 구매 로직 구현
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PurchaseScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                local.get('purchase'),
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
  }
}

// 선택된 옵션을 관리하기 위한 클래스
class SelectedOption {
  final String optionName;
  final String itemName;
  final ProductOptionDetail detail;
  int quantity;

  SelectedOption({
    required this.optionName,
    required this.itemName,
    required this.quantity,
    required this.detail,
  });
}