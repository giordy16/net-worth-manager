import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_images.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/utils/extensions/context_extensions.dart';

import '../../../app_dimensions.dart';
import '../../../models/obox/settings_obox.dart';
import '../../../objectbox.g.dart';

class OnboardingScreen extends StatefulWidget {
  static String path = "/OnboardingScreen";

  @override
  State<StatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  final pages = [
    OnboardingPage(
      AppImages.tutorial_1,
      "Keep track of your net worth easily",
      "Add your assets, liabilities and investments to know the value of your net worth in real time.",
    ),
    OnboardingPage(
      AppImages.tutorial_2,
      "Monitor the performance of your investments",
      "Keep track of your stock or ETF investments with interactive charts and valuable KPIs",
    ),
    OnboardingPage(
      AppImages.tutorial_3,
      "Get precious insights",
      "View valuable insights into the status and performance of your net worth",
    ),
  ];

  void openApp() {
    final settings = GetIt.I<Settings>();
    settings.showTutorial = false;
    GetIt.I<Store>().box<Settings>().put(settings);

    context.clearStackAndReplace(ScaffoldWithBottomNavigation.path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: PageView(
              children: pages,
              controller: controller,
            )),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.page!.toInt() == pages.length - 1) {
                    openApp();
                  } else {
                    controller.animateToPage(
                      (controller.page! + 1).toInt(),
                      duration: Duration(milliseconds: 100),
                      curve: Curves.ease,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: theme.colorScheme.onSurface),
                child: Container(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.arrow_forward,
                      color: theme.colorScheme.surface,
                    )),
              ),
            ),
            SizedBox(height: Dimensions.l)
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  String imagePath;
  String title;
  String subTitle;

  OnboardingPage(this.imagePath, this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(imagePath),
            )),
            SizedBox(height: Dimensions.l),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimensions.s),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: Dimensions.l),
          ],
        ),
      ),
    );
  }
}
