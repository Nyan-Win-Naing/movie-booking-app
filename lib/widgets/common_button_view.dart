import 'package:flutter/material.dart';
import 'package:movie_booking_app/config/config_values.dart';
import 'package:movie_booking_app/config/environment_config.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class CommonButtonView extends StatelessWidget {
  final String btnLabel;
  final bool isOnBoardingPage;
  final Function onTapCommonButton;
  final String keyName;

  CommonButtonView(this.btnLabel, this.onTapCommonButton, {this.isOnBoardingPage = false, this.keyName = ""});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapCommonButton();
      },
      child: Container(
        key: Key(keyName),
        height: MARGIN_XXLARGE + 10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: THEME_COLORS[EnvironmentConfig.CONFIG_THEME_COLOR],
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
          border: isOnBoardingPage ? Border.all(
            color: SUBSCRIPTION_TEXT_COLOR,
            width: 2,
          ) : null,
        ),
        child: Center(
          child: Text(
            btnLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}