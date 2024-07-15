import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:net_worth_manager/app_images.dart';
import 'package:net_worth_manager/ui/scaffold_with_bottom_navigation.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_params.dart';
import 'package:net_worth_manager/ui/screens/currency_selection/currency_selection_screen.dart';
import 'package:net_worth_manager/utils/extensions/context_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../app_dimensions.dart';
import '../../../i18n/strings.g.dart';
import '../../../models/obox/settings_obox.dart';
import '../../../objectbox.g.dart';

class OnboardingScreen extends StatefulWidget {
  static String path = "/OnboardingScreen";

  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  final pages = [
    OnboardingPage(
      AppImages.tutorial_1,
      t.onboarding_1_title,
      t.onboarding_1_subtitle,
    ),
    OnboardingPage(
      AppImages.tutorial_2,
      t.onboarding_2_title,
      t.onboarding_2_subtitle,
    ),
    OnboardingPage(
      AppImages.tutorial_3,
      t.onboarding_3_title,
      t.onboarding_3_subtitle,
    ),
    OnboardingPage(
      AppImages.tutorial_1,
      t.onboarding_4_title,
      t.onboarding_4_subtitle,
    ),
    OnboardingPage(
      AppImages.tutorial_4,
      t.onboarding_5_title,
      t.onboarding_5_subtitle,
    ),
  ];

  void openApp() {
    final settings = GetIt.I<Settings>();
    settings.showTutorial = false;
    GetIt.I<Store>().box<Settings>().put(settings);

    context.clearStackAndReplace(ScaffoldWithBottomNavigation.path);
  }

  void chooseMainCurrency() {
    context.push(CurrencySelectionScreen.route,
        extra: CurrencySelectionParams(
          selectedCurrency: GetIt.I<Settings>().defaultCurrency.target,
          onCurrencySelected: (c) {
            Settings settings = GetIt.I<Settings>();
            settings.defaultCurrency.target = c;
            GetIt.I<Store>().box<Settings>().put(settings);

            openApp();
          },
        ));
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
              controller: controller,
              children: pages,
            )),
            SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  type: WormType.thinUnderground,
                  activeDotColor: Colors.white),
            ),
            const SizedBox(
              height: 32,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.page!.toInt() == pages.length - 1) {
                    chooseMainCurrency();
                  } else {
                    controller.animateToPage(
                      (controller.page! + 1).toInt(),
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: theme.colorScheme.onSurface),
                child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Icon(
                      Icons.arrow_forward,
                      color: theme.colorScheme.surface,
                    )),
              ),
            ),
            const SizedBox(height: Dimensions.l)
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

  OnboardingPage(this.imagePath, this.title, this.subTitle, {super.key});

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
            const SizedBox(height: Dimensions.l),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Dimensions.s),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: Dimensions.l),
          ],
        ),
      ),
    );
  }
}
