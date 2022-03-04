import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/movie_seat_vo.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class MovieSeatItemView extends StatelessWidget {
  final CinemaSeatVO? mMovieSeatVO;

  MovieSeatItemView({required this.mMovieSeatVO});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      decoration: BoxDecoration(
        color: _getSeatColor(mMovieSeatVO),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(MARGIN_MEDIUM),
          topRight: Radius.circular(MARGIN_MEDIUM),
        ),
      ),
      child: Center(
        child: Text(
          mMovieSeatVO?.type == "space"
              ? ""
              : mMovieSeatVO?.seatName == ""
                  ? mMovieSeatVO?.symbol ?? ""
                  : mMovieSeatVO?.seatName ?? "",
          style: TextStyle(
            fontSize: mMovieSeatVO?.seatName == "" ? 14 : 7,
            color: mMovieSeatVO?.isSelected == true ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

Color _getSeatColor(CinemaSeatVO? movieSeat) {

  if (movieSeat?.type == "taken") {
    return MOVIE_SEAT_TAKEN_COLOR;
  } else if (movieSeat?.isSelected == true) {
    return ON_BOARDING_BACKGROUND_COLOR;
  } else if (movieSeat?.type == "available") {
    return MOVIE_SEAT_AVAILABLE_COLOR;
  } else {
    return Colors.white;
  }
}
