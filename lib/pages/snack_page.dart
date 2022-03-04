import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/pages/payment_page.dart';
import 'package:movie_booking_app/resources/back_action.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/viewitems/combo_view.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:movie_booking_app/widgets/title_text.dart';

class SnackPage extends StatefulWidget {
  final UserVO? userVo;
  int price;

  final TimeSlotVO? timeSlotVo;
  final List<CinemaSeatVO>? selectSeats;
  final MovieChooseDateVO? movieDate;
  final int movieId;
  final CinemaVO? cinemaVo;

  SnackPage({
    required this.userVo,
    required this.price,
    required this.timeSlotVo,
    required this.selectSeats,
    required this.movieDate,
    required this.movieId,
    required this.cinemaVo,
  });

  @override
  State<SnackPage> createState() => _SnackPageState();
}

class _SnackPageState extends State<SnackPage> {
  /// Model
  MovieModel _movieModel = MovieModelImpl();

  /// State
  List<SnackVO>? snacks;
  List<PaymentMethodVO>? paymentMethods;
  late int price;
  List<SnackVO>? selectedSnacks = [];

  @override
  void initState() {
    price = widget.price;
    // _movieModel.getSnacks("Bearer ${widget.userVo?.token}").then((snackList) {
    //   setState(() {
    //     snacks = snackList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    _movieModel.getSnacksFromDatabase("${widget.userVo?.token}").listen((snackList) {
      if(mounted) {
        setState(() {
          snacks = snackList;
        });
      }
    }).onError((error) {
      debugPrint(error.toString());
    });

    _movieModel
        .getPaymentMethodsFromDatabase("${widget.userVo?.token}")
        .listen((paymentMethods) {
      if(mounted) {
        setState(() {
          this.paymentMethods = paymentMethods;
        });
      }
    }).onError((error) {
      debugPrint(error.toString());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(snacks);

    selectedSnacks = snacks?.map((snack) => snack).where((snack) {
      int q = snack.quantity ?? 0;
      return q > 0;
    }).toList();

    print(selectedSnacks);

    return Scaffold(
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
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: MARGIN_MEDIUM_2),
                  SnackListSectionView(
                    snacks: snacks ?? [],
                    priceChange: (snackVo, itemCount, operator) {
                      print(
                          "Snack price: ${snackVo.id}, Item count: ${snackVo.quantity}");
                      setState(() {
                        int snackPrice = snackVo.price ?? 0;
                        if (operator == "plus") {
                          int eachTotalPrice = snackPrice * itemCount;
                          widget.price = widget.price + eachTotalPrice;
                        } else {
                          widget.price -= snackPrice;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: MARGIN_SMALL),
                  PromoCodeSectionView(),
                  const SizedBox(height: MARGIN_LARGE),
                  SubTotalView(
                    price: widget.price,
                  ),
                  const SizedBox(height: MARGIN_LARGE),
                  PaymentMethodSectionView(
                    paymentMethodList: paymentMethods ?? [],
                  ),
                  const SizedBox(height: MARGIN_XXLARGE * 2),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM_2),
                child: CommonButtonView(
                  "Pay \$${widget.price}",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          paymentAmount: widget.price,
                          userVo: widget.userVo,
                          timeSlotVo: widget.timeSlotVo,
                          selectSeats: widget.selectSeats,
                          movieDate: widget.movieDate,
                          movieId: widget.movieId,
                          cinemaVo: widget.cinemaVo,
                          snackList: selectedSnacks,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SnackListSectionView extends StatelessWidget {
  final List<SnackVO> snacks;
  final Function(SnackVO, int, String) priceChange;

  SnackListSectionView({required this.snacks, required this.priceChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snacks.length,
        itemBuilder: (BuildContext context, int index) {
          return ComboView(
            snack: snacks[index],
            priceChange: priceChange,
          );
        },
      ),
    );
  }
}

class PaymentMethodSectionView extends StatefulWidget {
  final List<PaymentMethodVO> paymentMethodList;

  PaymentMethodSectionView({required this.paymentMethodList});

  @override
  State<PaymentMethodSectionView> createState() =>
      _PaymentMethodSectionViewState();
}

class _PaymentMethodSectionViewState extends State<PaymentMethodSectionView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(PAYMENT_METHOD_TITLE),
          const SizedBox(height: MARGIN_MEDIUM_3),
          // EachPaymentMethod(
          //     const Icon(
          //       Icons.credit_score_outlined,
          //       color: Color.fromRGBO(128, 145, 178, 1.0),
          //       size: MARGIN_LARGE,
          //     ),
          //     CREDIT_CARD_LABEL,
          //     CARD_TYPES),
          // const SizedBox(height: MARGIN_MEDIUM_2),
          // EachPaymentMethod(
          //     const Icon(
          //       Icons.credit_card_rounded,
          //       color: Color.fromRGBO(128, 145, 178, 1.0),
          //       size: MARGIN_LARGE,
          //     ),
          //     ATM_CARD_LABEL,
          //     CARD_TYPES),
          // const SizedBox(height: MARGIN_MEDIUM_2),
          // EachPaymentMethod(
          //     const Icon(
          //       Icons.account_balance_wallet,
          //       color: Color.fromRGBO(128, 145, 178, 1.0),
          //       size: MARGIN_LARGE,
          //     ),
          //     E_WALLET_LABEL,
          //     E_WALLET_TYPE),

          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.paymentMethodList.length,
            itemBuilder: (BuildContext context, int index) {
              PaymentMethodVO currentMethod = widget.paymentMethodList[index];
              print(currentMethod.isSelected);
              return GestureDetector(
                onTap: () {
                  widget.paymentMethodList.forEach((pm) {
                    pm.isSelected = false;
                  });
                  setState(() {
                    currentMethod.isSelected = true;
                  });
                },
                child: EachPaymentMethod(
                  paymentIcon: Icon(
                    Icons.credit_score_outlined,
                    color: currentMethod.isSelected == false
                        ? Color.fromRGBO(128, 145, 178, 1.0)
                        : ON_BOARDING_BACKGROUND_COLOR,
                    size: MARGIN_LARGE,
                  ),
                  paymentMethod: currentMethod,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EachPaymentMethod extends StatelessWidget {
  final Icon paymentIcon;
  final PaymentMethodVO paymentMethod;

  EachPaymentMethod({required this.paymentIcon, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MARGIN_MEDIUM_2),
      child: Row(
        children: [
          paymentIcon,
          const SizedBox(width: MARGIN_LARGE),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentMethod.name ?? "",
                style: TextStyle(
                  fontSize: TEXT_REGULAR_3X,
                  color: paymentMethod.isSelected == false
                      ? Colors.black87
                      : ON_BOARDING_BACKGROUND_COLOR,
                ),
              ),
              const SizedBox(height: MARGIN_MEDIUM),
              Text(
                paymentMethod.description ?? "",
                style: TextStyle(
                  fontSize: TEXT_REGULAR_2X,
                  color: paymentMethod.isSelected == false
                      ? SUBSCRIPTION_TEXT_COLOR
                      : Color.fromRGBO(98, 62, 234, 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubTotalView extends StatelessWidget {
  final int price;

  SubTotalView({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Text(
        "Sub total : ${price}\$",
        style: const TextStyle(
          fontSize: TEXT_REGULAR_3X,
          fontWeight: FontWeight.w600,
          color: SNACK_PAGE_SUB_TOTAL_COLOR,
        ),
      ),
    );
  }
}

class PromoCodeSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PromoCodeTextFieldView(),
          const SizedBox(height: MARGIN_MEDIUM),
          Row(
            children: const [
              Text(
                SNACK_PAGE_NOT_HAVE_PROMO_CODE,
                style: TextStyle(
                  color: SUBSCRIPTION_TEXT_COLOR,
                  fontSize: TEXT_REGULAR_2X,
                ),
              ),
              SizedBox(width: MARGIN_SMALL),
              Text(
                SNACK_PAGE_PROMO_CODE_GET_NOW,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: TEXT_REGULAR_2X,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PromoCodeTextFieldView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TEXT_FIELD_HINT_COLOR),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: TEXT_FIELD_HINT_COLOR),
        ),
        hintText: "Enter promo code",
        hintStyle: TextStyle(
          color: SUBSCRIPTION_TEXT_COLOR,
          fontSize: TEXT_REGULAR_3X,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
