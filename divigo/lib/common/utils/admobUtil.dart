import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AdmobUtil {
  static final AdmobUtil instance = AdmobUtil._internal();
  factory AdmobUtil() => instance;
  AdmobUtil._internal();

  InterstitialAd? _interstitialAd;
  InterstitialAd? _lotteryInterstitialAd;

  int _numInterstitialLoadAttempts = 0;
  int _numLotteryInterstitialLoadAttempts = 0;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  static const AdRequest request = AdRequest();

  void createLotteryInterstitialAd({Function()? cb}) {
    InterstitialAd.load(
        // adUnitId: Platform.isAndroid
        //     ? 'ca-app-pub-3940256099942544/1033173712'
        //     : 'ca-app-pub-3940256099942544/4411468910',
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-8921630185723546/7942430580'
            : 'ca-app-pub-8921630185723546/9162075115',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _lotteryInterstitialAd = ad;
            _numLotteryInterstitialLoadAttempts = 0;
            _lotteryInterstitialAd!.setImmersiveMode(true);
            if (cb != null) {
              cb();
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numLotteryInterstitialLoadAttempts += 1;
            _lotteryInterstitialAd = null;
            if (_numLotteryInterstitialLoadAttempts < maxFailedLoadAttempts) {
              if (cb != null) {
                createLotteryInterstitialAd(cb:cb);
              }else{
                createLotteryInterstitialAd();
              }
            }else{
              if (cb != null) {
                cb();
              }
            }
          },
        ));
  }

  void showLotteryInterstitialAd({Function()? cb}) {
    if (_lotteryInterstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      if (cb != null) {
        cb();
      }
      return;
    }
    _lotteryInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        if (cb != null) {
          cb();
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        if (cb != null) {
          cb();
        }
      },
    );
    _lotteryInterstitialAd!.show();
    _lotteryInterstitialAd = null;
  }

  void createInterstitialAd({Function()? cb}) {
    InterstitialAd.load(
        // adUnitId: Platform.isAndroid
        //     ? 'ca-app-pub-3940256099942544/1033173712'
        //     : 'ca-app-pub-3940256099942544/4411468910',
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-8921630185723546/4319628777'
            : 'ca-app-pub-8921630185723546/6277941222',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            if (cb != null) {
              cb();
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd({Function()? cb}) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
        if (cb != null) {
          cb();
        }
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }
}
