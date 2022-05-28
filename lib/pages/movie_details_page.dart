import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/movie_details_bloc.dart';
import 'package:movie_booking_app/config/config_values.dart';
import 'package:movie_booking_app/config/environment_config.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/pages/movie_choose_time_page.dart';
import 'package:movie_booking_app/persistence/daos/movie_dao.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/viewitems/cast_view.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:movie_booking_app/widgets/galaxy_app_credits_view.dart';
import 'package:movie_booking_app/widgets/movie_app_credits_view.dart';
import 'package:movie_booking_app/widgets/rating_view.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;
  final UserVO? userVo;
  final bool isNowPlaying;

  MovieDetailsPage({
    required this.movieId,
    required this.userVo,
    required this.isNowPlaying,
  });

  final List<String> genreList = ["Mystery", "Adventure"];

  @override
  Widget build(BuildContext context) {
    print("UserVO from MovieDetail is ${userVo}");
    return ChangeNotifierProvider(
      create: (context) => MovieDetailsBloc(movieId, userVo, isNowPlaying),
      child: Scaffold(
        body: Selector<MovieDetailsBloc, MovieVO?>(
          selector: (context, bloc) => bloc.movieDetails,
          builder: (context, movieDetails, child) => Container(
            color: Colors.white,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    MovieDetailsSliverAppBarView(
                      () => Navigator.pop(context),
                      movie: movieDetails,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: MARGIN_MEDIUM_2),
                            child: MovieTimeRatingAndGenreView(
                              movie: movieDetails,
                            ),
                          ),
                          const SizedBox(height: MARGIN_MEDIUM_3),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: MARGIN_MEDIUM_2),
                            child: MoviePlotView(
                                plotSummary: movieDetails?.overview ?? ""),
                          ),
                          const SizedBox(height: MARGIN_MEDIUM_3),
                          DETAIL_PAGE_CREDITS_VIEWS[EnvironmentConfig
                                  .CONFIG_DETAIL_PAGE_CREDITS_VIEW] ??
                              Container(),
                          const SizedBox(height: MARGIN_XXLARGE + 30),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM_2),
                    child: CommonButtonView(
                      MOVIE_DETAILS_GET_TICKET_BUTTON_TEXT,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieChooseTimePage(
                                userVo: userVo, movieId: movieId),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MoviePlotView extends StatelessWidget {
  final String plotSummary;

  MoviePlotView({required this.plotSummary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(MOVIE_DETAILS_PLOT_SUMMARY_TITLE_TEXT),
        SizedBox(height: MARGIN_MEDIUM),
        Text(
          plotSummary,
          style: TextStyle(
            fontSize: TEXT_REGULAR_2X,
            height: 1.5,
            color: MOVIE_DETAILS_TEXT_COLOR,
          ),
        ),
      ],
    );
  }
}

class MovieTimeRatingAndGenreView extends StatelessWidget {
  final MovieVO? movie;

  MovieTimeRatingAndGenreView({required this.movie});

  @override
  Widget build(BuildContext context) {
    List<String> genreList = movie?.getGenreListAsStringList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieTitleView(
          title: movie?.title ?? "",
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        MovieTimeAndRatingView(
          rating: movie?.voteAverage ?? 0,
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...genreList.map((genre) => GenreChipView(genre)).toList(),
          ],
        ),
      ],
    );
  }
}

class GenreChipView extends StatelessWidget {
  final String genreText;

  GenreChipView(this.genreText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            shape: const StadiumBorder(
              side: BorderSide(color: TEXT_FIELD_HINT_COLOR),
            ),
            backgroundColor: Colors.white,
            label: Container(
              width: 75,
              padding: const EdgeInsets.symmetric(
                vertical: MARGIN_MEDIUM,
              ),
              child: Center(
                child: Text(
                  genreText,
                  style: const TextStyle(
                    color: MOVIE_DETAILS_GENRE_CHIP_TEXT_COLOR,
                    fontSize: TEXT_REGULAR_2X,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: MARGIN_MEDIUM_2,
          )
        ],
      ),
    );
  }
}

class MovieTimeAndRatingView extends StatelessWidget {
  final double rating;

  MovieTimeAndRatingView({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "1h 45m",
          style: TextStyle(
            fontSize: TEXT_REGULAR_3X,
            color: MOVIE_DETAILS_TEXT_COLOR,
          ),
        ),
        const SizedBox(width: MARGIN_MEDIUM_2),
        RatingView(),
        const SizedBox(width: MARGIN_MEDIUM_2),
        Text(
          "IMDb$rating",
          style: const TextStyle(
            fontSize: TEXT_REGULAR_3X,
            color: MOVIE_DETAILS_TEXT_COLOR,
          ),
        ),
      ],
    );
  }
}

class MovieTitleView extends StatelessWidget {
  final String title;

  MovieTitleView({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: TEXT_HEADING_2X,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MovieDetailsSliverAppBarView extends StatelessWidget {
  final Function onTapBack;
  final MovieVO? movie;

  MovieDetailsSliverAppBarView(this.onTapBack, {required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      expandedHeight: MOVIE_DETAILS_SLIVER_APP_BAR_HEIGHT,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned.fill(
                  child: MovieDetailsAppBarImageView(
                    imageUrl: movie?.posterPath ?? "",
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: PlayButtonIconView(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: MARGIN_XLARGE,
                      left: MARGIN_MEDIUM,
                    ),
                    child: BackButtonView(() {
                      onTapBack();
                    }),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 25,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MARGIN_XLARGE),
                  topRight: Radius.circular(MARGIN_XLARGE),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BackButtonView extends StatelessWidget {
  final Function onTapBack;

  BackButtonView(this.onTapBack);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onTapBack();
      },
      child: const Icon(
        Icons.chevron_left,
        color: Colors.white,
        size: MARGIN_XXLARGE,
      ),
    );
  }
}

class PlayButtonIconView extends StatelessWidget {
  const PlayButtonIconView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.play_circle_outline_rounded,
      size: MOVIE_PLAY_BUTTON_SIZE,
      color: Colors.white,
    );
  }
}

class MovieDetailsAppBarImageView extends StatelessWidget {
  String imageUrl;

  MovieDetailsAppBarImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? Image.network(
            "$IMAGE_BASE_URL$imageUrl",
            fit: BoxFit.cover,
          )
        : CircularProgressIndicator();
  }
}
