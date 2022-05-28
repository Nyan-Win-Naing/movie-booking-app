import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/home_bloc.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/pages/movie_details_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/viewitems/movie_view.dart';
import 'package:provider/provider.dart';

class MovieAppHomeScreenMovieView extends StatefulWidget {

  const MovieAppHomeScreenMovieView({Key? key}) : super(key: key);

  @override
  State<MovieAppHomeScreenMovieView> createState() =>
      _MovieAppHomeScreenMovieViewState();
}

class _MovieAppHomeScreenMovieViewState
    extends State<MovieAppHomeScreenMovieView> {
  int tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTabController(
          length: 2,
          child: TabBar(
            unselectedLabelColor: Color.fromRGBO(80, 87, 101, 1.0),
            labelColor: MOVIE_APP_SECONDARY_COLOR,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: MOVIE_APP_SECONDARY_COLOR,
              ),
              insets: EdgeInsets.symmetric(horizontal: MARGIN_XXLARGE),
            ),
            tabs: const [
              Tab(
                child: Text(
                  "Now Playing",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: TEXT_REGULAR_2X,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Up Coming",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: TEXT_REGULAR_2X,
                  ),
                ),
              )
            ],
            onTap: (index) {
              setState(() {
                tabBarIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: MARGIN_LARGE),
        (tabBarIndex == 0)
            ? Selector<HomeBloc, List<MovieVO>>(
                selector: (context, bloc) => bloc.getNowPlayingMovies ?? [],
                builder: (context, nowPlayingMovies, child) =>
                    Selector<HomeBloc, UserVO?>(
                  selector: (context, bloc) => bloc.userVo,
                  builder: (context, user, child) => Movies2xGridView(
                      movieList: nowPlayingMovies, userVo: user, isNowPlaying: true,),
                ),
              )
            : Selector<HomeBloc, List<MovieVO>>(
                selector: (context, bloc) => bloc.getUpcomingMovies ?? [],
                builder: (context, upComingMovies, child) =>
                    Selector<HomeBloc, UserVO?>(
                  selector: (context, bloc) => bloc.userVo,
                  builder: (context, user, child) =>
                      Movies2xGridView(movieList: upComingMovies, userVo: user, isNowPlaying: false,),
                ),
              ),
      ],
    );
  }
}

class Movies2xGridView extends StatelessWidget {
  final List<MovieVO> movieList;
  final UserVO? userVo;
  final bool isNowPlaying;

  Movies2xGridView({
    required this.movieList,
    required this.userVo,
    required this.isNowPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(left: MARGIN_MEDIUM_3),
      itemCount: movieList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 160 / 275,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _navigateToMovieDetailsScreen(
                context, movieList[index].id ?? 0, userVo, isNowPlaying);
          },
          child: MovieView(
            movie: movieList[index],
          ),
        );
      },
    );
  }

  void _navigateToMovieDetailsScreen(
      BuildContext context, int? movieId, UserVO? userVo, bool isNowPlaying) {
    if (movieId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(
            movieId: movieId,
            userVo: userVo,
            isNowPlaying: isNowPlaying,
          ),
        ),
      );
    }
  }
}
