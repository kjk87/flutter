
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

const int maxFailedLoadAttempts = 3;
const String usdtMintAddress = 'Es9vMFrzaCERhGNN2W4N6QDhxYYz6nXBhKL7UwvKW7hC';
const String divcMintAddress = 'dvcLTWJJK67Gun3awBcq3U2f99j3iWe2Eq9Qd6NWmxt';

class WalletUtil {

  static final WalletUtil instance = WalletUtil._internal();
  factory WalletUtil() => instance;
  WalletUtil._internal();

  late ReownAppKitModal _appKitModal;
  bool _walletInit = false;

  ReownAppKitModal get appKitModal => _appKitModal;
  bool get walletInit => _walletInit;

  void init(BuildContext context) {
    ReownAppKitModalNetworks.removeSupportedNetworks(NetworkUtils.eip155);
    ReownAppKitModalNetworks.removeTestNetworks();

    _appKitModal = ReownAppKitModal(
        context: context,
        projectId: '1752f68b7b823a767abd8e38fea6dfe5',
        metadata: const PairingMetadata(
          name: 'DivCow',
          description: 'DivCow',
          url: 'https://divcow.com',
          icons: ['assets/images/ic_profile_default.png'],
        ),
        requiredNamespaces: {
          'solana': RequiredNamespace.fromJson({
            'chains': ReownAppKitModalNetworks.getAllSupportedNetworks(
              namespace: 'solana',
            ).map((chain) => 'solana:${chain.chainId}').toList(),
            'methods': NetworkUtils.defaultNetworkMethods[NetworkUtils.solana]!
                .toList(),
            'events': [],
          }),
        },
        includedWalletIds: {
          '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0',
          '971e689d0a5be527bac79629b4ee9b925e82208e5168b733496a09c0faed0709',
          '0b415a746fb9ee99cce155c2ceca0c6f6061b1dbca2d722b3ba16381d0562150',
          '15c8b91ade1a4e58f3ce4e7a0dd7f42b47db0c8df7e0d84f63eb39bcb96c4e0f',
          'f2436c67184f158d1beda5df53298ee84abfc367581e4505134b5bcf5f46697d'
        });

    _appKitModal.init().then((value) {
      _walletInit = true;
      log('_appKitModal init');
    });
  }

  Future<void> getUSDTBalance(String walletAddress) async {
    final rpcClient = RpcClient('https://api.mainnet-beta.solana.com');

    // Wallet의 USDT 계좌 조회
    final tokenAccounts = await rpcClient.getTokenAccountsByOwner(
      walletAddress,
      const TokenAccountsFilter.byMint(usdtMintAddress),
    );

    if (tokenAccounts.value.isNotEmpty) {
      print('USDT Balance: ${tokenAccounts.value[0].account.data}');
    } else {
      print('No USDT balance found.');
    }
  }


}