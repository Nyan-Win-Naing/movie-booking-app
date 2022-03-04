import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';

class TitleText extends StatelessWidget {

  final String title;

  TitleText(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: TITLE_TEXT_COLOR,
        fontSize: TEXT_HEADING_1X,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
