import 'package:flutter/material.dart';
import 'package:chanzel/core/constants/app_colors.dart';

class TextStyles {
  TextStyles._();

  static const TextStyle black31Bold = TextStyle(
    fontSize: 31,
    fontFamily: 'AvenirNext',
    fontWeight: FontWeight.w700,
    color: ColorsManger.blackColor,
  );

  static const TextStyle gray18medium = TextStyle(
    fontSize: 18,
    fontFamily: 'Avenir',
    fontWeight: FontWeight.w500,
    color: ColorsManger.grayColor,
  );

  static const TextStyle white20medium = TextStyle(
    fontSize: 20,
    fontFamily: 'CircularStd',
    fontWeight: FontWeight.w500,
    color: ColorsManger.whiteColor,
  );
}
