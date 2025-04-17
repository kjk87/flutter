import 'package:divigo/screens/games/number_baseball_game.dart';
import 'package:divigo/screens/games/pattern_memory_game.dart';
import 'package:divigo/screens/signin/siginup_screen.dart';
import 'package:divigo/screens/wallet/point_history_screen.dart';
import 'package:flutter/material.dart';
import 'common/utils/admobUtil.dart';
import 'common/utils/solanaWalletUtil.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/event/event_screen.dart';
import 'screens/reward/reward_screen.dart';
import 'screens/wallet/wallet_screen.dart';
import 'screens/wallet/token_detail_screen.dart';
import 'screens/reward/invite_history_screen.dart';
import 'package:divigo/core/localization/app_localization_delegate.dart';
import 'package:divigo/core/localization/language_constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/language_provider.dart';
import 'screens/reward/mini_game_screen.dart';
import 'screens/reward/invite_screen.dart';
import 'screens/reward/attendance_screen.dart';
import 'screens/reward/pedometer_screen.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/reward/channel_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:divigo/core/services/network_connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SolanaWalletUtil.instance.init();
  AdmobUtil.instance.createInterstitialAd();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late NetworkConnectivityService _connectivityService;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // _connectivityService = NetworkConnectivityService();
    // _listenToNetworkChanges();
  }

  // void _listenToNetworkChanges() {
  //   _connectivityService.networkStatusController.stream.listen((status) {
  //     if (mounted) {
  //       _scaffoldMessengerKey.currentState?.showSnackBar(
  //         SnackBar(
  //           content: Text(status.message),
  //           duration: const Duration(seconds: 2),
  //           behavior: SnackBarBehavior.floating,
  //           margin: const EdgeInsets.all(16),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }

  @override
  void dispose() {
    // _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: Builder(
        builder: (context) {
          final languageProvider = Provider.of<LanguageProvider>(context);

          return MaterialApp(
            scaffoldMessengerKey: _scaffoldMessengerKey,
            title: 'DIV',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF7C4DFF),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: 'Pretendard',
            ),
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: supportedLocales,
            initialRoute: '/',
            routes: {
              // '/': (context) => const SignupScreen(
              //     joinType: 'email',
              //     joinPlatform: 'email',
              //     platformKey: 'email',
              //     platformEmail: 'email',
              //     deviceId: 'email'),
              '/': (context) => const SplashScreen(),
              '/home': (context) => const HomeScreen(),
              '/wallet': (context) => const WalletScreen(),
              '/event': (context) => const EventScreen(),
              '/games/number-baseball': (context) => NumberBaseballGame(),
              '/games/pattern-memory': (context) => const PatternMemoryGame(),
              '/reward': (context) => const RewardScreen(),
              '/reward/mini-game': (context) => const MiniGameScreen(),
              '/reward/invite': (context) => const InviteScreen(),
              '/reward/attendance': (context) => AttendanceScreen(),
              '/reward/pedometer': (context) => const PedometerScreen(),
              '/reward/channel': (context) => const ChannelScreen(),
              '/reward/invite-history': (context) =>
                  const InviteHistoryScreen(),
              '/more/point-history': (context) => const PointHistoryScreen(),
              '/shop': (context) => const ShopScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/token-detail':
                  final symbol = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (context) => TokenDetailScreen(symbol: symbol),
                  );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
