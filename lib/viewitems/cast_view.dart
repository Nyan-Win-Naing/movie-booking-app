import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class MovieDetailsCastView extends StatelessWidget {
  final ActorVO credit;
  final bool isMovieApp;

  MovieDetailsCastView({required this.credit, this.isMovieApp = false});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarRadius = (!isMovieApp) ? (screenHeight / 20) : (screenHeight / 30);
    String? profilePath = credit.profilePath;
    return Container(
      margin: EdgeInsets.only(right: (!isMovieApp) ? MARGIN_LARGE : 0, bottom: (!isMovieApp) ? 0 : MARGIN_MEDIUM_2),
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(
          profilePath != null ? "$IMAGE_BASE_URL$profilePath" : "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-Clipart.png",
        ),
      ),
    );
  }
}
