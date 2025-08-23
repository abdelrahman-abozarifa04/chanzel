import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chanzel/features/onboarding/domain/models/onboarding_model.dart';
import 'package:chanzel/core/constants/app_fonts.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingModel page;

  const OnboardingPageContent({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(page.imagePath, height: 300),
        const SizedBox(height: 40),
        Text(
          page.title,
          style: TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          page.description,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
