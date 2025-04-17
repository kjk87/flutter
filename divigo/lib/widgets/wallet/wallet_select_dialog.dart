// 지갑 선택 다이얼로그
import 'package:divigo/common/utils/solanaWalletUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/localization/app_localization.dart';

class WalletSelectorDialog extends StatelessWidget {
  final Function(WalletType) onSelect;

  const WalletSelectorDialog({
    Key? key,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalization.of(context).get('selectWallet'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onSelect(WalletType.phantom);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/phantom_logo.png',  // 팬텀 로고 이미지
                      width: 32,
                      height: 32,
                    ),
                    SizedBox(width: 12),
                    Text(
                      AppLocalization.of(context).get('phantom'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                onSelect(WalletType.solflare);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/solflare_logo.png',  // 솔플레어 로고 이미지
                      width: 32,
                      height: 32,
                    ),
                    SizedBox(width: 12),
                    Text(
                      AppLocalization.of(context).get('solflare'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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