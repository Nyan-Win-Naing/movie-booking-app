import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/resources/dimens.dart';

class MovieDetailsCastView extends StatelessWidget {
  final ActorVO credit;

  MovieDetailsCastView({required this.credit});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarRadius = screenHeight / 20;
    String? profilePath = credit.profilePath;
    return Container(
      margin: EdgeInsets.only(right: MARGIN_LARGE),
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundImage: NetworkImage(
          profilePath != null ? "$IMAGE_BASE_URL$profilePath" : "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-Clipart.png",
        ),
      ),
    );
  }
}
