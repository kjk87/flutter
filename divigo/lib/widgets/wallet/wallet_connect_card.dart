import 'package:divigo/widgets/wallet/wallet_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/utils/solanaWalletUtil.dart';
import '../../core/localization/app_localization.dart';

class WalletConnectCard extends StatelessWidget {
  final VoidCallback onConnect;

  const WalletConnectCard({
    super.key,
    required this.onConnect,
  });

  String get _metamaskSvg => '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20.5 4L13 8.5L14 5.5L20.5 4Z" fill="#E17726"/>
  <path d="M3.5 4L11 8.5L10 5.5L3.5 4Z" fill="#E27625"/>
  <path d="M18 16.5L20.5 12L15 12.5L18 16.5Z" fill="#E27625"/>
  <path d="M6 16.5L3.5 12L9 12.5L6 16.5Z" fill="#E27625"/>
  <path d="M9 12.5L11 8.5L3.5 4L6 16.5L9 12.5Z" fill="#E27625"/>
  <path d="M15 12.5L13 8.5L20.5 4L18 16.5L15 12.5Z" fill="#E27625"/>
  <path d="M9 12.5L6 16.5L11 15.5L9 12.5Z" fill="#D5BFB2"/>
  <path d="M15 12.5L18 16.5L13 15.5L15 12.5Z" fill="#D5BFB2"/>
  <path d="M13 15.5L11 15.5L11.5 19L13 15.5Z" fill="#233447"/>
  <path d="M11 15.5L13 15.5L12.5 19L11 15.5Z" fill="#233447"/>
</svg>
''';

  String get _walletConnectSvg => '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M7 10.5C10.5 7 13.5 7 17 10.5" stroke="#3B99FC" stroke-width="2" stroke-linecap="round"/>
  <path d="M8.5 12C10.8333 9.66667 13.1667 9.66667 15.5 12" stroke="#3B99FC" stroke-width="2" stroke-linecap="round"/>
  <path d="M10 13.5C11.3333 12.1667 12.6667 12.1667 14 13.5" stroke="#3B99FC" stroke-width="2" stroke-linecap="round"/>
  <circle cx="12" cy="12" r="9" stroke="#3B99FC" stroke-width="2"/>
</svg>
''';

  Future<void> _connectWallet(WalletType type) async {
    SolanaWalletUtil.instance.state = WalletConnectionStatus.connecting;

    try {
      await SolanaWalletUtil.instance.connectWallet(type, (info) async {
        print('info : ${info.publicKey}');
        SolanaWalletUtil.instance.state = info != null
            ? WalletConnectionStatus.connected
            : WalletConnectionStatus.error;

        print('state : ${SolanaWalletUtil.instance.state}');
        if (SolanaWalletUtil.instance.state ==
            WalletConnectionStatus.connected) {
          final balance = await SolanaWalletUtil.instance.getDivcBalance();
          SolanaWalletUtil.instance.walletConnectionInfo?.balance = balance;
        }
        onConnect.call();
      });
    } catch (e) {
      print('지갑 연결 오류: $e');
      SolanaWalletUtil.instance.state = WalletConnectionStatus.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple[900]!,
            Colors.blue[900]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalization.of(context).get('connectWalletTitle'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalization.of(context).get('connectWalletDesc'),
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => WalletSelectorDialog(
                  onSelect: (walletType) {
                    _connectWallet(walletType);
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple[900],
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalization.of(context).get('connect'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.string(
                icon == 'metamask' ? _metamaskSvg : _walletConnectSvg,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
