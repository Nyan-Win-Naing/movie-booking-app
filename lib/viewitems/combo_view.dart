import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

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
                    if(widget.snackVo.quantity != 0) {
                      itemCount--;
                      int quantity = widget.snackVo.quantity ?? 0;
                      widget.snackVo.quantity = quantity - 1;
                    }
                    widget.priceChange(widget.snackVo, widget.snackVo.quantity ?? 0, "minus");
                },
                child: ItemIncrementDecrementView("-"),
              ),
              ItemIncrementDecrementView(
                "${widget.snackVo.quantity}",
                isItemCount: true,
              ),
              GestureDetector(
                onTap: () {
                    itemCount++;
                    int quantity = widget.snackVo.quantity ?? 0;
                    widget.snackVo.quantity = quantity + 1;
                    widget.priceChange(widget.snackVo, 1, "plus");
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
