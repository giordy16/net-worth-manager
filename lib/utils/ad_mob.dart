import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class ADMob {
  static String getBottomBarAdId() {
    return Platform.isAndroid
        ? 'ca-app-pub-8885650576105496/1827534367'
        : 'ca-app-pub-8885650576105496/1827534367';
  }

  static String getPopUpAdId() {
    return Platform.isAndroid
        ? 'ca-app-pub-8885650576105496/5078198440'
        : 'ca-app-pub-8885650576105496/5078198440';
  }

  static showPopUpAd({required Function onAdDismissed}) {
    InterstitialAd.load(
        adUnitId: ADMob.getPopUpAdId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                  onAdDismissed();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
            ad.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            onAdDismissed();
          },
        ));
  }
}
