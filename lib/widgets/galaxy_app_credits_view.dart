import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/movie_details_bloc.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/viewitems/cast_view.dart';
import 'package:movie_booking_app/widgets/movie_app_credits_view.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class GalaxyAppCreditsView extends StatelessWidget {
  const GalaxyAppCreditsView({
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
        Container(
          height: MOVIE_DETAILS_CAST_LIST_HEIGHT,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
            scrollDirection: Axis.horizontal,
            itemCount: credits.length,
            itemBuilder: (BuildContext context, int index) {
              return MovieDetailsCastView(
                credit: credits[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
