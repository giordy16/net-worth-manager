import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_screen.dart';
import 'package:net_worth_manager/ui/screens/settings/settings_page.dart';

class ScaffoldWithBottomNavigation extends StatefulWidget {
  static String path = "/";

  @override
  State<StatefulWidget> createState() => _ScaffoldWithBottomNavigationState();
}

class _ScaffoldWithBottomNavigationState
    extends State<ScaffoldWithBottomNavigation> {
  int _selectedIndex = 0;
  final widgets = [HomePage(), InsightsScreen(), SettingsScreen()];
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.insights), label: "Insights"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
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
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: widgets),
    );
  }
}
