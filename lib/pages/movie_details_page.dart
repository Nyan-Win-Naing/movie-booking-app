import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/pages/movie_choose_time_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/viewitems/cast_view.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:movie_booking_app/widgets/rating_view.dart';
import 'package:movie_booking_app/widgets/title_text.dart';

class MovieDetailsPage extends StatefulWidget {

  final int movieId;
  final UserVO? userVo;

  MovieDetailsPage({required this.movieId, required this.userVo});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final List<String> genreList = ["Mystery", "Adventure"];

  /// Model
  MovieModel _movieModel = MovieModelImpl();

  /// States
  MovieVO? movieDetails;
  List<ActorVO>? credits;
  late List<ActorVO> cast;
  late List<ActorVO> crew;

  @override
  void initState() {

    /// Movie Details
    // _movieModel.getMovieDetails(widget.movieId).then((movieDetails) {
    //   setState(() {
    //     this.movieDetails = movieDetails;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Movie Details Database
    _movieModel.getMovieDetailsFromDatabase(widget.movieId).listen((movieDetails) {
      if(mounted) {
        setState(() {
          this.movieDetails = movieDetails;
        });
      }
    }).onError((error) {
      debugPrint(error.toString());
    });

    _movieModel.getCreditsByMovie(widget.movieId).then((castAndCrew) {
      if(mounted) {
        setState(() {
          cast = castAndCrew.first ?? [];
          crew = castAndCrew[1] ?? [];
          credits = cast + crew;
        });
      }
    }).catchError((error) {
      debugPrint(error.toString());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
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
                        child:
                            MovieTimeRatingAndGenreView(movie: movieDetails,),
                      ),
                      const SizedBox(height: MARGIN_MEDIUM_3),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: MARGIN_MEDIUM_2),
                        child: MoviePlotView(plotSummary: movieDetails?.overview ?? ""),
                      ),
                      const SizedBox(height: MARGIN_MEDIUM_3),
                      Container(
                        child: CastSectionView(credits: credits ?? [],),
                      ),
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
                        builder: (context) => MovieChooseTimePage(userVo: widget.userVo, movieId: widget.movieId),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
              return MovieDetailsCastView(credit: credits[index],);
            },
          ),
        ),
      ],
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
        MovieTitleView(title: movie?.title ?? "",),
        const SizedBox(height: MARGIN_MEDIUM_2),
        MovieTimeAndRatingView(rating: movie?.voteAverage ?? 0,),
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
    return imageUrl.isNotEmpty ? Image.network(
      "$IMAGE_BASE_URL$imageUrl",
      fit: BoxFit.cover,
    ) : CircularProgressIndicator();
  }
}
