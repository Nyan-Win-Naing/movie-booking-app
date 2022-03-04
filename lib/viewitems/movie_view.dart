import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class MovieView extends StatelessWidget {
  final MovieVO? movie;

  MovieView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: MARGIN_MEDIUM_3),
      width: MOVIE_LIST_ITEM_WIDTH,
      child: Column(
        children: [
          Container(
            height: MOVIE_IMAGE_HEIGHT,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
              image: DecorationImage(
                image: NetworkImage(
                  "$IMAGE_BASE_URL${movie?.posterPath ?? ""}",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM_2),
          Text(
            movie?.title ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM),
          const Text(
            "Mystery/Adventure . 1h 45m",
            style: TextStyle(
              fontSize: 10,
              color: SUBSCRIPTION_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}
