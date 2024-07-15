import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_screen.dart';
import 'package:net_worth_manager/ui/screens/settings/settings_page.dart';
import 'package:net_worth_manager/ui/widgets/modal/bottom_sheet.dart';

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
  final widgets = [const HomePage(), const InsightsScreen(), const SettingsScreen()];
  final PageController _controller = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.home),
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
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: widgets),
    );
  }
}
