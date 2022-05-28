import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/movie_details_bloc.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/viewitems/cast_view.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class MovieAppCreditsView extends StatelessWidget {
  const MovieAppCreditsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieDetailsBloc, List<ActorVO>>(
      selector: (context, bloc) => bloc.credits ?? [],
      builder: (context, credits, child) =>
          CastSectionView(
            credits: credits,
          ),
    );
  }
}

class CastSectionView extends StatelessWidget {
  final List<ActorVO> credits;

  CastSectionView({required this.credits});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: TitleText(MOVIE_DETAILS_CAST_TITLE_TEXT),
        ),
        const SizedBox(height: MARGIN_MEDIUM),
        MovieAppCastsView(credits: credits),
      ],
    );
  }
}

class MovieAppCastsView extends StatelessWidget {
  const MovieAppCastsView({
    Key? key,
    required this.credits,
  }) : super(key: key);

  final List<ActorVO> credits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MARGIN_MEDIUM),
        Container(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: credits.map((c) => MovieDetailsCastView(credit: c, isMovieApp: true,)).toList(),
            spacing: MARGIN_MEDIUM_2,
          ),
        ),
      ],
    );
  }
}
