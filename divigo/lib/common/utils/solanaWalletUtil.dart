import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:bs58/bs58.dart';
import 'package:dio/dio.dart';
import 'package:divigo/common/utils/UrlSchemeHandler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinenacl/tweetnacl.dart';
import 'package:pinenacl/x25519.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/TokenAccount.dart';

const String mainnetRpcUrl = 'https://api.mainnet-beta.solana.com';
const String mainnetWsUrl = 'wss://api.mainnet-beta.solana.com';
const String mainnetCluster = 'mainnet-beta';

// 지갑 타입 열거형
enum WalletType { phantom, solflare }

// 지갑 연결 상태 열거형
enum WalletConnectionStatus { disconnected, connecting, connected, error }

// 지갑 연결 정보 클래스
class WalletConnectionInfo {
  final String publicKey;
  final String session;
  final String encryptionPublicKey;
  final WalletType walletType;
  final String dappEncryptionPublicKey;
  final String dappEncryptionPrivateKey;
  final String nonce;
  double? balance;

  WalletConnectionInfo({
    required this.publicKey,
    required this.session,
    required this.encryptionPublicKey,
    required this.walletType,
    required this.dappEncryptionPublicKey,
    required this.dappEncryptionPrivateKey,
    required this.nonce,
    this.balance,
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() => {
    'publicKey': publicKey,
    'session': session,
    'encryptionPublicKey': encryptionPublicKey,
    'walletType': walletType.toString().split('.').last,
    'dappEncryptionPublicKey': dappEncryptionPublicKey,
    'dappEncryptionPrivateKey': dappEncryptionPrivateKey,
    'nonce': nonce,
    'balance': balance,
  };

  // JSON 문자열에서 객체 생성
  static WalletConnectionInfo fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return WalletConnectionInfo(
      publicKey: json['publicKey'],
      session: json['session'],
      encryptionPublicKey: json['encryptionPublicKey'],
      walletType: WalletType.values.firstWhere(
              (e) => e.toString().split('.').last == json['walletType']),
      dappEncryptionPublicKey: json['dappEncryptionPublicKey'],
      dappEncryptionPrivateKey: json['dappEncryptionPrivateKey'],
      nonce: json['nonce'],
    );
  }
}

class KeyPairInfo {
  final String publicKey;
  final String secretKey;

  KeyPairInfo({
    required this.publicKey,
    required this.secretKey,
  });

  // JSON으로 변환
  Map<String, dynamic> toJson() => {
    'publicKey': publicKey,
    'secretKey': secretKey,
  };

  // JSON 문자열에서 객체 생성
  static KeyPairInfo fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return KeyPairInfo(
      publicKey: json['publicKey'],
      secretKey: json['secretKey'],
    );
  }
}

Future<WalletConnectionInfo?> getWalletConnectionInfo() async {
  const storage = FlutterSecureStorage();
  var userStr = await storage.read(key: 'walletConnectionInfo');
  if (userStr != null) {
    return WalletConnectionInfo.fromJsonString(userStr);
  }
  return null;
}

class SolanaWalletUtil {
  static final SolanaWalletUtil instance = SolanaWalletUtil._internal();
  factory SolanaWalletUtil() => instance;
  SolanaWalletUtil._internal();

  late WalletConnectionInfo? _walletConnectionInfo;
  WalletConnectionStatus _state = WalletConnectionStatus.disconnected;
  late var _solanaService = SolanaService();

  WalletConnectionInfo? get walletConnectionInfo => _walletConnectionInfo;

  WalletConnectionStatus get state => _state;
  set state(WalletConnectionStatus value) {
    _state = value;
  }

  get solanaService => _solanaService;

  void init() async {
    _solanaService = SolanaService();
    _walletConnectionInfo = await getWalletConnectionInfo();
    if (_walletConnectionInfo != null) {
      _state = WalletConnectionStatus.connected;
      _walletConnectionInfo!.balance = await getDivcBalance();
    }

    // await UrlSchemeHandler.initUriHandler();
  }

  disconnect() async {
    final walletConnectionInfo = this._walletConnectionInfo;
    if (walletConnectionInfo != null) {
      await _solanaService.disconnectWallet(info: walletConnectionInfo);
    }
  }

  connectWallet(WalletType type, WalletConnectionInfoListener listener) async{
    switch (type) {
      case WalletType.phantom:
        await _solanaService.connectPhantomWallet(listener);
        break;
      case WalletType.solflare:
        await _solanaService.connectSolflareWallet(listener);
        break;
    }
  }

  Future<double> getDivcBalance() async {
    return await _solanaService.getDivcBalance(walletAddress: _walletConnectionInfo!.publicKey);
  }

  Future<double> getUsdtBalance() async {
    return await _solanaService.getUsdtBalance(walletAddress: _walletConnectionInfo!.publicKey);
  }
}

typedef WalletConnectionInfoListener = void Function(WalletConnectionInfo);
typedef TransactionListener = void Function();

// 통합 Solana 서비스
class SolanaService {
  static const String rpcUrl = 'https://api.mainnet-beta.solana.com';
  static const String testnetRpcUrl = 'https://api.testnet.solana.com';
  static const String devnetRpcUrl = 'https://api.devnet.solana.com';
  static AppLinks? _appLinks;
  static StreamSubscription? _subscription;  // URI 스트림 구독 저장
  SolanaService() {
    _appLinks = AppLinks();
  }

  static const String _appUrlScheme = 'div'; // 앱의 URL 스킴으로 변경 필요
  static const String _usdtMintAddress = 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB'; // Solana USDT mint address
  static const String _usdtMintAuthorityAddress = 'Q6XprfkF8RQQKoQVG33xT88H7wi8Uk1B1CC7YAs69Gi'; // Solana USDT mint address
  static const String _divcMintAddress = 'dvcLTWJJK67Gun3awBcq3U2f99j3iWe2Eq9Qd6NWmxt';
  static const String _divcMintAuthorityAddress = 'AUKzB4tazoGXozdoAqCEP24qKqUmEy7RXjCw5YtZurSW';

  KeyPairInfo generateKeyPair() {
    final privateKey = PrivateKey.generate();
    final publicKey = privateKey.publicKey;
    return KeyPairInfo(
        publicKey: base58.encode(publicKey.asTypedList),
        secretKey: base58.encode(privateKey.asTypedList));
  }

  // Phantom 지갑 연결
  connectPhantomWallet(WalletConnectionInfoListener listener) async {
    final keyPair = generateKeyPair();
    try {
      final phantomUrl = Uri.parse('https://phantom.app/ul/v1/connect').replace(
        queryParameters: {
          'app_url': 'https://divigo.site', // 당신의 앱 식별자 URL
          'dapp_encryption_public_key':
          keyPair.publicKey, // base58 encoded public key
          'redirect_link': '$_appUrlScheme://callback',
          'cluster': 'devnet',
        },
      );

      print('Connecting to Phantom with URL: ${phantomUrl.toString()}');

      await _subscription?.cancel();
      _subscription = _appLinks?.uriLinkStream.listen((uri) {
        print('uri: ${uri.toString()}');

        final phantomEncryptionPublicKey =
        uri.queryParameters['phantom_encryption_public_key'];
        final nonce = uri.queryParameters['nonce'];
        final data = uri.queryParameters['data'];

        if (phantomEncryptionPublicKey == null ||
            nonce == null ||
            data == null) {
          throw Exception('Phantom 지갑 연결 실패: public key not received');
        }
        final decryptedData = decryptData(
            data: data,
            nonce: nonce,
            encryptionPublicKey: phantomEncryptionPublicKey,
            dappSecretKey: keyPair.secretKey);
        if (decryptedData == null) {
          throw Exception('Phantom 지갑 연결 실패: public key not received');
        }
        final info = WalletConnectionInfo(
            publicKey: decryptedData['public_key']!,
            session: decryptedData['session']!,
            encryptionPublicKey: phantomEncryptionPublicKey,
            walletType: WalletType.phantom,
            dappEncryptionPublicKey: keyPair.publicKey,
            dappEncryptionPrivateKey: keyPair.secretKey,
            nonce: nonce);

        const storage = FlutterSecureStorage();
        storage.write(
            key: 'walletConnectionInfo', value: jsonEncode(info.toJson()));
        SolanaWalletUtil.instance._walletConnectionInfo = info;
        listener(info);

      }, onError: (err) {
        print('URI 스트림 에러: $err');
      });

      if (await canLaunchUrl(phantomUrl)) {
        await launchUrl(
          phantomUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Phantom 앱을 실행할 수 없습니다.';
      }
    } catch (e) {
      print('Phantom 지갑 연결 오류: $e');
    }
  }

  // Solflare 지갑 연결
  connectSolflareWallet(WalletConnectionInfoListener listener) async {
    final keyPair = generateKeyPair();
    try {
      final solflareUrl =
      Uri.parse('https://solflare.com/ul/v1/connect').replace(
        queryParameters: {
          'app_url': 'https://divigo.site', // 당신의 앱 식별자 URL
          'dapp_encryption_public_key': keyPair.publicKey,
          'redirect_link': '$_appUrlScheme://callback',
        },
      );

      await _subscription?.cancel();
      _subscription = _appLinks?.uriLinkStream.listen((uri) {
        print('uri: ${uri.toString()}');

        final solflareEncryptionPublicKey =
        uri.queryParameters['solflare_encryption_public_key'];
        final nonce = uri.queryParameters['nonce'];
        final data = uri.queryParameters['data'];

        if (solflareEncryptionPublicKey == null ||
            nonce == null ||
            data == null) {
          throw Exception('Solflare 지갑 연결 실패: public key not received');
        }

        final decryptedData = decryptData(
            data: data,
            nonce: nonce,
            encryptionPublicKey: solflareEncryptionPublicKey,
            dappSecretKey: keyPair.secretKey);
        if (decryptedData == null) {
          throw Exception('Phantom 지갑 연결 실패: public key not received');
        }
        final info = WalletConnectionInfo(
            publicKey: decryptedData['public_key']!,
            session: decryptedData['session']!,
            encryptionPublicKey: solflareEncryptionPublicKey,
            walletType: WalletType.phantom,
            dappEncryptionPublicKey: keyPair.publicKey,
            dappEncryptionPrivateKey: keyPair.secretKey,
            nonce: nonce);

        const storage = FlutterSecureStorage();
        storage.write(
            key: 'walletConnectionInfo', value: jsonEncode(info.toJson()));
        SolanaWalletUtil.instance._walletConnectionInfo = info;
        listener(info);

      }, onError: (err) {
        print('URI 스트림 에러: $err');
      });

      UrlSchemeHandler.onSchemeDetected.listen((url) {
        print('URL 수신: $url');
        final Uri resultUri = Uri.parse(url);
        final solflareEncryptionPublicKey =
        resultUri.queryParameters['solflare_encryption_public_key'];
        final nonce = resultUri.queryParameters['nonce'];
        final data = resultUri.queryParameters['data'];

        if (solflareEncryptionPublicKey == null ||
            nonce == null ||
            data == null) {
          throw Exception('Solflare 지갑 연결 실패: public key not received');
        }

        final decryptedData = decryptData(
            data: data,
            nonce: nonce,
            encryptionPublicKey: solflareEncryptionPublicKey,
            dappSecretKey: keyPair.secretKey);
        if (decryptedData == null) {
          throw Exception('Phantom 지갑 연결 실패: public key not received');
        }
        final info = WalletConnectionInfo(
            publicKey: decryptedData['public_key']!,
            session: decryptedData['session']!,
            encryptionPublicKey: solflareEncryptionPublicKey,
            walletType: WalletType.phantom,
            dappEncryptionPublicKey: keyPair.publicKey,
            dappEncryptionPrivateKey: keyPair.secretKey,
            nonce: nonce);

        const storage = FlutterSecureStorage();
        storage.write(
            key: 'walletConnectionInfo', value: jsonEncode(info.toJson()));
        SolanaWalletUtil.instance._walletConnectionInfo = info;
        listener(info);
      });

      if (await canLaunchUrl(solflareUrl)) {
        await launchUrl(
          solflareUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Solflare 앱을 실행할 수 없습니다.';
      }
    } catch (e) {
      print('Solflare 지갑 연결 오류: $e');
    }
  }

  // 데이터 복호화
  Map<String, dynamic>? decryptData({
    required String data,
    required String nonce,
    required String encryptionPublicKey,
    required String dappSecretKey,
  }) {
    try {
      // base58로 인코딩된 데이터를 변환
      final Uint8List encryptedData = base58.decode(data);
      final Uint8List nonceBytes = base58.decode(nonce);

      // private key와 phantom public key를 바이트로 변환
      final privateKey = PrivateKey(base58.decode(dappSecretKey));
      final publicKey = PublicKey(base58.decode(encryptionPublicKey));

      // Box 생성 및 복호화

      final box = Box(myPrivateKey: privateKey, theirPublicKey: publicKey);
      final decryptedBytes =
      box.decrypt(ByteList(encryptedData.toList()), nonce: nonceBytes);
      // UTF-8로 디코딩하고 JSON 파싱
      final decryptedString = utf8.decode(decryptedBytes);
      return jsonDecode(decryptedString);
    } catch (e) {
      print('데이터 복호화 오류: $e');
      return null;
    }
  }

  // 데이터 복호화
  ({Uint8List encryptedPayload, Uint8List nonce})? encryptData({
    required String data,
    required String encryptionPublicKey,
    required String dappSecretKey,
  }) {
    try {
      List<int> bytesData = utf8.encode(data);

      // private key와 phantom public key를 바이트로 변환
      final privateKey = PrivateKey(base58.decode(dappSecretKey));
      final publicKey = PublicKey(base58.decode(encryptionPublicKey));
      final nonce = TweetNaCl.randombytes(24);
      // Box 생성 및 복호화

      final box = Box(myPrivateKey: privateKey, theirPublicKey: publicKey);
      final encryptedPayload =
      box.encrypt(Uint8List.fromList(bytesData), nonce: nonce);


      return (
      encryptedPayload: Uint8List.fromList(encryptedPayload.cipherText),
      nonce: Uint8List.fromList(encryptedPayload.nonce)
      );
    } catch (e) {
      print('데이터 복호화 오류: $e');
      return null;
    }
  }

  // USDT 잔액 조회
  Future<double> getUsdtBalance({
    required String walletAddress,
  }) async {
    return getTokenBalance(
      walletAddress: walletAddress,
      tokenMintAddress: _usdtMintAddress,
    );
  }

  // DIVC 잔액 조회
  Future<double> getDivcBalance({
    required String walletAddress,
  }) async {
    return getTokenBalance(
      walletAddress: walletAddress,
      tokenMintAddress: _divcMintAddress,
    );
  }

  // 일반 토큰 잔액 조회
  Future<double> getTokenBalance({
    required String walletAddress,
    required String tokenMintAddress,
  }) async {
    try {
      final params = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "getTokenAccountsByOwner",
        "params": [
          walletAddress,
          {
            "programId": "TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb"
          },
          {
            "encoding": "jsonParsed"
          }
        ]
      };

      Map<String, String> header = {
        "accept": "application/json",
      };

      final url = rpcUrl;
      // final url = devnetRpcUrl;

      var dio = Dio();
      var response = await dio.post(url,
          options: Options(headers: header), data: params);
      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          var body = response.data;
          final value = body['result']['value'];
          if(value.length > 0){
            final account = TokenAccount.fromJson(value[0] as Map<String, dynamic>);
            return account.account.data.parsed.info.tokenAmount.uiAmount;
          }
        }
      }
      return 0.0;
    } catch (e) {
      print('토큰 잔액 조회 오류: $e');
      return 0.0;
    }
  }


  // 지갑 연결 해제
  Future<void> disconnectWallet({required WalletConnectionInfo info}) async {
    try {
      // Uri disconnectUrl;
      // switch (info.walletType) {
      //   case WalletType.phantom:
      //     disconnectUrl = Uri.parse('https://phantom.app/ul/v1/disconnect');
      //     break;
      //   case WalletType.solflare:
      //     disconnectUrl = Uri.parse('https://solflare.com/ul/v1/disconnect');
      //     break;
      // }
      //
      // disconnectUrl = disconnectUrl.replace(queryParameters: {
      //   'dapp_encryption_public_key': info.dappEncryptionPublicKey,
      //   'redirect_link': '$_appUrlScheme://callback',
      //   'nonce': info.nonce,
      // });
      //
      // await launchUrl(disconnectUrl);

      const storage = FlutterSecureStorage();
      storage.delete(key: 'walletConnectionInfo');
      SolanaWalletUtil.instance._walletConnectionInfo = null;
      SolanaWalletUtil.instance._state = WalletConnectionStatus.disconnected;
    } catch (e) {
      print('지갑 연결 해제 오류: $e');
    }
  }
}
