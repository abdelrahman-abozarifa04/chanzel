// lib/presentation/onboarding/widgets/page_indicator.dart

import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPageIndex;

  const OnboardingPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => _buildDot(context: context, index: index),
      ),
    );
  }

  Widget _buildDot({required BuildContext context, required int index}) {
    bool isActive = currentPageIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? ColorsManger.naiveColor
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
