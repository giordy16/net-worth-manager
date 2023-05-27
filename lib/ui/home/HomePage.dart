import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../investments/InvestmentsPage.dart';
import '../overview/OverViewPage.dart';

class HomePage extends StatefulWidget {
  int initialPage;

  HomePage({this.initialPage = 0});

  @override
  State<StatefulWidget> createState() => HomePageState();

}

class HomePageState extends State <HomePage> {

  int _selectedIndex = 0;
  List<Widget> _homeWidgets = [OverviewPage(), InvestmentsPage(), OverviewPage()];

  @override
  void initState() {
    _selectedIndex = widget.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomAppBar(),
      body: SafeArea(
        child: _homeWidgets.elementAt(_selectedIndex),
      ),
    );
  }

  NavigationBar CustomAppBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home'
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.attach_money),
          icon: Icon(Icons.attach_money_outlined),
          label: 'Investimenti',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: 'Impostazioni',
        ),
      ],
    );
  }

}

