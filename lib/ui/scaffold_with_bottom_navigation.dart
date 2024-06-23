import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/ui/screens/home/home_page_screen.dart';
import 'package:net_worth_manager/ui/screens/insights/insights_screen.dart';
import 'package:net_worth_manager/ui/screens/settings/settings_page.dart';

// class ScaffoldWithBottomNavigation extends StatefulWidget {
//   int? initialPosition;
//
//   ScaffoldWithBottomNavigation(this.initialPosition);
//
//   @override
//   State<StatefulWidget> createState() => _ScaffoldWithBottomNavigationState();
// }

class ScaffoldWithBottomNavigation extends StatelessWidget {
  const ScaffoldWithBottomNavigation({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

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
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
      ),
      body: navigationShell,
    );
  }
}
