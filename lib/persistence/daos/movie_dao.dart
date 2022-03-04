import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

class MovieDao {
  static final MovieDao _singleton = MovieDao._internal();

  factory MovieDao() {
    return _singleton;
  }

  MovieDao._internal();

  void saveMovies(List<MovieVO>? movies) async {
    Map<int, MovieVO> movieMap = Map.fromIterable(movies ?? [],
        key: (movie) => movie.id, value: (movie) => movie);
    await getMovieBox().putAll(movieMap);
  }

  void saveSingleMovie(MovieVO? movie) async {
    await getMovieBox().put(movie!.id, movie);
  }

  List<MovieVO> getAllMovies() {
    return getMovieBox().values.toList();
  }

  MovieVO? getMovieById(int movieId) {
    return getMovieBox().get(movieId);
  }

  /// Reactive Programming
  Stream<void> getAllMovieEventStream() {
    return getMovieBox().watch();
  }

  Stream<List<MovieVO>> getNowPlayingMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element.isNowPlaying ?? false)
        .toList());
  }

  Stream<List<MovieVO>> getUpcomingMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element.isUpComing ?? false)
        .toList());
  }

  Stream<MovieVO?> getMovieByIdStream(int movieId) {
    return Stream.value(getMovieById(movieId));
  }

  Box<MovieVO> getMovieBox() {
    return Hive.box<MovieVO>(BOX_NAME_MOVIE_VO);
  }

  /// New Functions
  List<MovieVO> getNowPlayingMovies() {
    if(getAllMovies() != null && getAllMovies().isNotEmpty) {
      return getAllMovies()
          .where((element) => element.isNowPlaying ?? false)
          .toList();
    } else {
      return [];
    }
  }

  List<MovieVO> getUpcomingMovies() {
    if(getAllMovies() != null && getAllMovies().isNotEmpty) {
      return getAllMovies()
          .where((element) => element.isUpComing ?? false)
          .toList();
    } else {
      return [];
    }
  }

  MovieVO? getMovie(int movieId) {
    if(getMovieById(movieId) != null) {
      return getMovieById(movieId);
    } else {
      return null;
    }
  }
}
