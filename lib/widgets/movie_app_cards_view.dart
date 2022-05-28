import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/payment_bloc.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/viewitems/card_section_view.dart';
import 'package:provider/provider.dart';

class MovieAppCardsView extends StatelessWidget {
  const MovieAppCardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PaymentBloc, UserVO?>(
        selector: (context, bloc) => bloc.userVo,
        builder: (context, userVo, child) {
          List<CardVO> cardList = userVo?.cards ?? [];
          return Container(
            height: MediaQuery.of(context).size.height / 3.5,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
              children: cardList
                  .map(
                    (card) => CardSectionView(
                      cardIndex: 0,
                      currentPageIndex: 0,
                      cardVo: card,
                      isGalaxyApp: false,
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }
}
