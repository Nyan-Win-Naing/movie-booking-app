import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/payment_bloc.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';
import 'package:movie_booking_app/pages/movie_details_page.dart';
import 'package:movie_booking_app/pages/payment_form_page.dart';
import 'package:movie_booking_app/pages/voucher_page.dart';
import 'package:movie_booking_app/resources/back_action.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_booking_app/resources/selected_card.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  final int paymentAmount;
  final UserVO? userVo;

  final TimeSlotVO? timeSlotVo;
  final List<CinemaSeatVO>? selectSeats;
  final MovieChooseDateVO? movieDate;
  final int movieId;
  final CinemaVO? cinemaVo;
  final List<SnackVO>? snackList;

  PaymentPage({
    required this.paymentAmount,
    required this.userVo,
    required this.timeSlotVo,
    required this.selectSeats,
    required this.movieDate,
    required this.movieId,
    required this.cinemaVo,
    required this.snackList,
  });

  @override
  Widget build(BuildContext context) {
    // print("Parent Widget : ${cardVo?.id}");
    return ChangeNotifierProvider(
      create: (context) => PaymentBloc(paymentAmount, userVo, timeSlotVo,
          selectSeats, movieDate, movieId, cinemaVo, snackList),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              backAction(context);
            },
            child: const Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: MARGIN_XXLARGE,
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: MARGIN_MEDIUM_2),
                  PaymentAmountSectionView(
                    paymentAmount: paymentAmount,
                  ),
                  const SizedBox(height: MARGIN_MEDIUM_3),
                  Builder(
                    builder: (context) {
                      return CardCarouselSectionView(
                        userVo: userVo,
                        cardChange: (cardVo) {
                          // setState(() {
                          //   this.cardVo = cardVo;
                          // });
                          PaymentBloc bloc = Provider.of<PaymentBloc>(context, listen: false);
                          bloc.onChangeCard(cardVo);
                        },
                      );
                    }
                  ),
                  const SizedBox(height: MARGIN_LARGE),
                  AddNewCardView(
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentFormPage(
                          userVo: userVo,
                          refreshPaymentPageCards: () {},
                        ),
                      ),
                    ),
                    // .then((value) => getProfile()),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM_2),
                  child: Selector<PaymentBloc, CardVO?>(
                    selector: (context, bloc) => bloc.cardVo,
                    builder: (context, cardVo, child) =>
                        CommonButtonView(
                          "Purchase",
                              () {
                            // _movieModel
                            //     .postCheckout(
                            //     "Bearer ${userVo?.token}",
                            //     paymentAmount,
                            //     userVo,
                            //     timeSlotVo,
                            //     selectSeats,
                            //     movieDate,
                            //     movieId,
                            //     cinemaVo,
                            //     snackList,
                            //     cardVo)
                            //     .then((voucher) {
                            //   // setState(() {
                            //   voucherVo = voucher;
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => VoucherPage(
                            //         movieId: widget.movieId,
                            //         userVo: widget.userVo,
                            //         cinemaVo: widget.cinemaVo,
                            //         voucherVo: voucherVo,
                            //       ),
                            //     ),
                            //   );
                            //   // });
                            // }).catchError((error) {
                            //   debugPrint(error.toString());
                            //   print(error);
                            // });
                                print("Chose Card VO is : ${cardVo?.id}.......");
                          },
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewCardView extends StatelessWidget {
  final Function onTapAddNewCard;

  AddNewCardView(this.onTapAddNewCard);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapAddNewCard();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
        child: Row(
          children: const [
            Icon(
              Icons.add_circle,
              size: MARGIN_XLARGE,
              color: Color.fromRGBO(19, 194, 140, 1.0),
            ),
            SizedBox(width: MARGIN_MEDIUM_2),
            Text(
              PAYMENT_PAGE_ADD_NEW_CARD,
              style: TextStyle(
                fontSize: TEXT_REGULAR_3X,
                color: Color.fromRGBO(19, 194, 140, 1.0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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

class CardSectionView extends StatelessWidget {
  final int cardIndex;
  final int currentPageIndex;

  final CardVO? cardVo;

  CardSectionView(
      {required this.cardIndex,
      required this.currentPageIndex,
      required this.cardVo});

  @override
  Widget build(BuildContext context) {
    // print("Card Index is $cardIndex");
    // print("Current Page Index is $currentPageIndex");

    if (cardIndex == currentPageIndex) {
      print(cardVo?.id);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
          horizontal: MARGIN_LARGE, vertical: MARGIN_MEDIUM_2),
      decoration: BoxDecoration(
        // color: cardIndex == currentPageIndex
        //     ? CURRENT_PAYMENT_CARD_BACKGROUND_COLOR
        //     : PAYMENT_CARD_BACKGROUND_COLOR,
        color: CURRENT_PAYMENT_CARD_BACKGROUND_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
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

class PaymentAmountSectionView extends StatelessWidget {
  final int paymentAmount;

  PaymentAmountSectionView({required this.paymentAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            PAYMENT_AMOUNT_LABEL,
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              color: SUBSCRIPTION_TEXT_COLOR,
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM_2),
          Text(
            "\$ ${paymentAmount}",
            style: const TextStyle(
              fontSize: TEXT_BIG,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
