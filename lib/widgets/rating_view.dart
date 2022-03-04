import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class RatingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 5.0,
      itemBuilder: (BuildContext context, int index) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: MARGIN_LARGE,
      itemPadding: const EdgeInsets.only(left: MARGIN_SMALL),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
