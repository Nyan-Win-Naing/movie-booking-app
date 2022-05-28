import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/payment_bloc.dart';
import 'package:movie_booking_app/config/config_values.dart';
import 'package:movie_booking_app/config/environment_config.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:provider/provider.dart';

class CardSectionView extends StatelessWidget {
  final int cardIndex;
  final int currentPageIndex;

  final CardVO? cardVo;

  /// is galaxy app or movie app
  final bool isGalaxyApp;

  CardSectionView({
    required this.cardIndex,
    required this.currentPageIndex,
    required this.cardVo,
    this.isGalaxyApp = true,
  });

  @override
  Widget build(BuildContext context) {
    // print("Card Index is $cardIndex");
    // print("Current Page Index is $currentPageIndex");

    if (cardIndex == currentPageIndex) {
      print(cardVo?.id);
    }
    return GestureDetector(
      onTap: () {
        if(!isGalaxyApp) {
          PaymentBloc bloc = Provider.of(context, listen: false);
          bloc.onTapCard(cardVo ?? CardVO());
        }
      },
      child: Container(
        width: (isGalaxyApp) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 2.6/3,
        margin: (isGalaxyApp) ? null : EdgeInsets.only(right: MARGIN_MEDIUM_2),
        padding: EdgeInsets.only(
            left: MARGIN_LARGE, right: MARGIN_LARGE, top: MARGIN_MEDIUM_2, bottom: MARGIN_MEDIUM_2),
        decoration: BoxDecoration(
          // color: cardIndex == currentPageIndex
          //     ? CURRENT_PAYMENT_CARD_BACKGROUND_COLOR
          //     : PAYMENT_CARD_BACKGROUND_COLOR,
          color: THEME_COLORS[EnvironmentConfig.CONFIG_THEME_COLOR],
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
          border: (cardVo?.isSelected ?? false) ? Border.all(color: MOVIE_APP_SECONDARY_COLOR, width: MARGIN_SMALL) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardHeaderView(),
            Text(
              cardVo?.cardNumber ?? "",
              style: const TextStyle(
                fontSize: TEXT_BIG,
                color: Colors.white,
              ),
            ),
            CardBottomView(
              cardVo: cardVo,
            ),
          ],
        ),
      ),
    );
  }
}

class CardBottomView extends StatelessWidget {
  final CardVO? cardVo;

  CardBottomView({required this.cardVo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CardInfoView(
          infoTitle: "CARD HOLDER",
          infoText: cardVo?.cardHolder ?? "",
          crossAlign: CrossAxisAlignment.start,
        ),
        const Spacer(),
        CardInfoView(
          infoTitle: "EXPIRES",
          infoText: cardVo?.expirationDate ?? "",
          crossAlign: CrossAxisAlignment.end,
        )
      ],
    );
  }
}

class CardInfoView extends StatelessWidget {
  final String infoTitle;
  final String infoText;
  final CrossAxisAlignment crossAlign;

  CardInfoView({
    required this.infoTitle,
    required this.infoText,
    required this.crossAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(
          infoTitle,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: ON_BOARDING_WELCOME_APP_TEXT_COLOR,
          ),
        ),
        SizedBox(height: MARGIN_MEDIUM),
        Text(
          infoText,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_3X,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CardHeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          "Visa",
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_HEADING_1X,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Icon(
          Icons.more_horiz,
          color: Colors.white,
          size: MARGIN_LARGE,
        ),
      ],
    );
  }
}
