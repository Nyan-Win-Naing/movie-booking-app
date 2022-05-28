import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/blocs/snack_bloc.dart';
import 'package:movie_booking_app/config/config_values.dart';
import 'package:movie_booking_app/config/environment_config.dart';
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
import 'package:provider/provider.dart';

class SnackPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // print(snacks);
    //
    // selectedSnacks = snacks?.map((snack) => snack).where((snack) {
    //   int q = snack.quantity ?? 0;
    //   return q > 0;
    // }).toList();
    //
    // print(selectedSnacks);

    return ChangeNotifierProvider(
      create: (context) => SnackBloc(
          userVo, price, timeSlotVo, selectSeats, movieDate, movieId, cinemaVo),
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: MARGIN_MEDIUM_2),
                    Selector<SnackBloc, List<SnackVO>>(
                      selector: (context, bloc) => bloc.snacks ?? [],
                      shouldRebuild: (previous, next) => previous != next,
                      builder: (context, snacks, child) => SnackListSectionView(
                        snacks: snacks,
                        priceChange: (snackVo, itemCount, operator) {},
                      ),
                    ),
                    const SizedBox(height: MARGIN_SMALL),
                    PromoCodeSectionView(),
                    const SizedBox(height: MARGIN_LARGE),
                    Selector<SnackBloc, int>(
                      selector: (context, bloc) => bloc.price,
                      builder: (context, price, child) => SubTotalView(
                        price: price,
                      ),
                    ),
                    const SizedBox(height: MARGIN_LARGE),
                    Selector<SnackBloc, List<PaymentMethodVO>>(
                      selector: (context, bloc) => bloc.paymentMethods ?? [],
                      builder: (context, paymentMethods, child) =>
                          PaymentMethodSectionView(
                        paymentMethodList: paymentMethods,
                      ),
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
                  child: Selector<SnackBloc, int>(
                      selector: (context, bloc) => bloc.price,
                      builder: (context, price, child) {
                        return CommonButtonView(
                          "Pay \$${price}",
                          () {
                            SnackBloc bloc =
                                Provider.of<SnackBloc>(context, listen: false);
                            List<SnackVO> selectedSnacks =
                                bloc.getAllSelectedSnacks();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  paymentAmount: price,
                                  userVo: userVo,
                                  timeSlotVo: timeSlotVo,
                                  selectSeats: selectSeats,
                                  movieDate: movieDate,
                                  movieId: movieId,
                                  cinemaVo: cinemaVo,
                                  snackList: selectedSnacks,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ),
            ],
          ),
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

class ComboView extends StatelessWidget {
  final SnackVO snack;
  final Function(SnackVO, int, String) priceChange;

  ComboView({required this.snack, required this.priceChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
        bottom: MARGIN_LARGE,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ComboItemsView(snackVo: snack),
          ),
          const SizedBox(width: MARGIN_MEDIUM_3),
          Expanded(
            flex: 1,
            child: ComboItemPrice(snackVo: snack, priceChange: priceChange),
          ),
        ],
      ),
    );
  }
}

class ComboItemPrice extends StatefulWidget {
  final SnackVO snackVo;
  final Function(SnackVO, int, String) priceChange;

  ComboItemPrice({required this.snackVo, required this.priceChange});

  @override
  State<ComboItemPrice> createState() => _ComboItemPriceState();
}

class _ComboItemPriceState extends State<ComboItemPrice> {
  int itemCount = 0;
  SnackVO? clickedSnack;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${widget.snackVo.price}\$",
            style: const TextStyle(
              fontSize: TEXT_REGULAR_3X,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  SnackBloc bloc =
                      Provider.of<SnackBloc>(context, listen: false);
                  bloc.onTapMinus(widget.snackVo);
                },
                child: ItemIncrementDecrementView("-"),
              ),
              Builder(builder: (context) {
                return ItemIncrementDecrementView(
                  "${widget.snackVo.quantity}",
                  isItemCount: true,
                );
              }),
              GestureDetector(
                onTap: () {
                  print(
                      "Snack of widget: ${widget.snackVo.name} and ${widget.snackVo.quantity}.....");
                  SnackBloc bloc =
                      Provider.of<SnackBloc>(context, listen: false);
                  bloc.onTapPlus(widget.snackVo);
                },
                child: ItemIncrementDecrementView(
                  "+",
                  isIncrement: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemIncrementDecrementView extends StatelessWidget {
  final String label;
  final bool isIncrement;
  final bool isItemCount;

  BorderRadius? borderRadius;

  ItemIncrementDecrementView(this.label,
      {this.isItemCount = false, this.isIncrement = false});

  @override
  Widget build(BuildContext context) {
    borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(MARGIN_MEDIUM),
      bottomLeft: Radius.circular(MARGIN_MEDIUM),
    );

    if (isIncrement) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(MARGIN_MEDIUM),
        bottomRight: Radius.circular(MARGIN_MEDIUM),
      );
    } else if (isItemCount) {
      borderRadius = null;
    }

    return Container(
      width: 30,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: SUBSCRIPTION_TEXT_COLOR,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: TEXT_REGULAR_3X,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class ComboItemsView extends StatelessWidget {
  final SnackVO snackVo;

  ComboItemsView({required this.snackVo});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snackVo.name ?? "",
            style: const TextStyle(
              fontSize: TEXT_REGULAR_3X,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: MARGIN_MEDIUM),
          Text(
            snackVo.description ?? "",
            style: TextStyle(
              height: 1.4,
              fontSize: TEXT_REGULAR_2X,
              color: SUBSCRIPTION_TEXT_COLOR,
            ),
          ),
        ],
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
                        // : ON_BOARDING_BACKGROUND_COLOR,
                        : SECONDARY_THEME_AND_TEXT_COLORS[
                            EnvironmentConfig.CONFIG_SECONDARY_COLOR],
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
                      // : ON_BOARDING_BACKGROUND_COLOR,
                      : SECONDARY_THEME_AND_TEXT_COLORS[
                          EnvironmentConfig.CONFIG_SECONDARY_COLOR],
                ),
              ),
              const SizedBox(height: MARGIN_MEDIUM),
              Text(
                paymentMethod.description ?? "",
                style: TextStyle(
                  fontSize: TEXT_REGULAR_2X,
                  color: paymentMethod.isSelected == false
                      ? SUBSCRIPTION_TEXT_COLOR
                      // : Color.fromRGBO(98, 62, 234, 0.7),
                      : SECONDARY_THEME_AND_TEXT_COLORS[
                          EnvironmentConfig.CONFIG_SECONDARY_COLOR],
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
