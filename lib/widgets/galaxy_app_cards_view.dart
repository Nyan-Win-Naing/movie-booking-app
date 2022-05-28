import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/payment_bloc.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/viewitems/card_section_view.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GalaxyAppCardsView extends StatelessWidget {
  const GalaxyAppCardsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PaymentBloc, UserVO?>(
      selector: (context, bloc) => bloc.userVo,
      builder: (context, userVo, child) {
        return Builder(builder: (context) {
          return CardCarouselSectionView(
            userVo: userVo,
            cardChange: (cardVo) {
              // setState(() {
              //   this.cardVo = cardVo;
              // });
              PaymentBloc bloc =
              Provider.of<PaymentBloc>(context, listen: false);
              bloc.onChangeCard(cardVo);
            },
          );
        });
      },
    );
  }
}

class CardCarouselSectionView extends StatefulWidget {
  final UserVO? userVo;
  final Function(CardVO) cardChange;

  CardCarouselSectionView({required this.userVo, required this.cardChange});

  @override
  State<CardCarouselSectionView> createState() =>
      _CardCarouselSectionViewState();
}

class _CardCarouselSectionViewState extends State<CardCarouselSectionView> {
  int _carouselPageIndex = 0;

  List<int> cardLastNumbers = [8014, 8015, 8016];

  @override
  Widget build(BuildContext context) {
    UserVO? userVo = widget.userVo;
    List<CardVO> cardList = userVo?.cards ?? [];
    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 210,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            _carouselPageIndex = index;
            widget.cardChange(cardList[index]);
          },
        ),
        items: cardList.length != 0
            ? cardList
            .map((card) => Builder(
          builder: (BuildContext context) {
            return CardSectionView(
              cardVo: card,
              currentPageIndex: cardList.indexOf(card),
              cardIndex: _carouselPageIndex,
            );
          },
        ))
            .toList()
            : [],
      ),
    );
  }
}