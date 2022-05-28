import 'package:flutter/material.dart';
import 'package:movie_booking_app/blocs/home_bloc.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/pages/home_page.dart';
import 'package:movie_booking_app/pages/movie_details_page.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/viewitems/movie_view.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:provider/provider.dart';



class GalaxyAppHomeScreenMoviesView extends StatelessWidget {

  const GalaxyAppHomeScreenMoviesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Selector<HomeBloc, List<MovieVO>>(
          selector: (context, bloc) => bloc.getNowPlayingMovies ?? [],
          builder: (context, nowPlayingMovies, child) =>
              Selector<HomeBloc, UserVO?>(
                selector: (context, bloc) => bloc.userVo,
                builder: (context, user, child)  =>
                    MovieListSectionView(
                      title: HOME_PAGE_NOW_SHOWING_TITLE,
                      onTapMovie: (movieId) => _navigateToMovieDetailsScreen(
                          context, movieId, user, true),
                      movies: nowPlayingMovies,
                    ),
              ),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        Selector<HomeBloc, List<MovieVO>>(
          selector: (context, bloc) => bloc.getUpcomingMovies ?? [],
          builder: (context, getUpcomingMovies, child) =>
              Selector<HomeBloc, UserVO?>(
                selector: (context, bloc) => bloc.userVo,
                builder: (context, userVo, child) =>
                    MovieListSectionView(
                      title: HOME_PAGE_COMING_SOON_TITLE,
                      onTapMovie: (movieId) => _navigateToMovieDetailsScreen(
                          context, movieId, userVo, false),
                      movies: getUpcomingMovies,
                    ),
              ),
        ),
      ],
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

class MovieListSectionView extends StatelessWidget {
  final String title;
  final Function(int?) onTapMovie;
  final List<MovieVO>? movies;

  MovieListSectionView({
    required this.title,
    required this.onTapMovie,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
          child: TitleText(title),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        HorizontalMovieListView(
          onTapMovie: (movieId) => this.onTapMovie(movieId),
          movieList: movies,
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? movieList;

  HorizontalMovieListView({
    required this.onTapMovie,
    required this.movieList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_VIEW_HEIGHT,
      child: (movieList != null)
          ? ListView.builder(
        padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
        scrollDirection: Axis.horizontal,
        itemCount: movieList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => onTapMovie(movieList?[index].id),
            child: MovieView(
              movie: movieList?[index],
            ),
          );
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
