import 'package:flutter/material.dart';
import 'package:movie_booking_app/pages/authentication_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ON_BOARDING_BACKGROUND_COLOR,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: MARGIN_XLARGE),
              height: MediaQuery.of(context).size.height * 3 / 4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/onboarding_image.png",
                      width: MediaQuery.of(context).size.width * 1.8 / 2,
                    ),
                    const SizedBox(
                      height: MARGIN_LARGE * 3,
                    ),
                    const Text(
                      WELCOME_TITLE,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: TEXT_HEADING_2X,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: MARGIN_MEDIUM),
                    const Text(
                      ON_BOARDING_WELCOME_TEXT,
                      style: TextStyle(
                        color: ON_BOARDING_WELCOME_APP_TEXT_COLOR,
                        fontSize: TEXT_REGULAR_2X,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
              child: CommonButtonView(
                ON_BOARDING_GET_STARTED_BUTTON_TEXT,
                () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthenticationPage(),
                    ),
                  )
                },
                isOnBoardingPage: true,
                keyName: "on-boarding-button-key",
              ),
            ),
            const SizedBox(height: MARGIN_MEDIUM_2),
          ],
        ),
      ),
    );
  }
}
