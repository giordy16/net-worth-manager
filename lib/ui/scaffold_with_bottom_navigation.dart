import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_screen.dart';
import 'package:net_worth_manager/ui/screens/settings/settings_page.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';
import 'package:net_worth_manager/utils/ad_mob.dart';

import '../app_images.dart';
import '../i18n/strings.g.dart';

class ScaffoldWithBottomNavigation extends StatefulWidget {
  const ScaffoldWithBottomNavigation({super.key});

  static String path = "/";
  static bool noInternetConnection = false;

  static void updateScreens() {
    HomePage.shouldUpdatePage = true;
    InsightsScreen.shouldUpdatePage = true;

    if (GetIt.I.isRegistered<HomePageScreenState>()) {
      GetIt.I<HomePageScreenState>().updateKeepAlive();
    }
    if (GetIt.I.isRegistered<InsightsScreenState>()) {
      GetIt.I<InsightsScreenState>().updateKeepAlive();
    }
  }

  static void unregisterScreenStates() {
    if (GetIt.I.isRegistered<HomePageScreenState>()) {
      GetIt.I.unregister(instance: GetIt.I<HomePageScreenState>());
    }
    if (GetIt.I.isRegistered<InsightsScreenState>()) {
      GetIt.I.unregister(instance: GetIt.I<InsightsScreenState>());
    }
  }

  @override
  State<StatefulWidget> createState() => _ScaffoldWithBottomNavigationState();
}

class _ScaffoldWithBottomNavigationState
    extends State<ScaffoldWithBottomNavigation> {
  int _selectedIndex = 0;
  final widgets = [
    const HomePage(),
    const InsightsScreen(),
    const SettingsScreen()
  ];
  final PageController _controller = PageController();

  BannerAd? _bannerAd;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAd();

      if (ScaffoldWithBottomNavigation.noInternetConnection) {
        showOkOnlyBottomSheet(
          context,
          t.offline_message,
          imageAboveMessage: AppImages.noConnection,
        );
      }
    });
    super.initState();
  }

  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: ADMob.getBottomBarAdId(),
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_bannerAd != null) SizedBox(height: 60, child: AdWidget(ad: _bannerAd!)),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: t.home),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.insights), label: t.insights),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings), label: t.settings),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              _controller.jumpToPage(index);
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: widgets),
    );
  }
}
