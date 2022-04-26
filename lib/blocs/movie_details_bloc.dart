import 'package:flutter/foundation.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

class MovieDetailsBloc extends ChangeNotifier {
  /// States
  MovieVO? movieDetails;
  List<ActorVO>? credits;
  late List<ActorVO> cast;
  late List<ActorVO> crew;

  bool _dispose = false;

  /// Models
  MovieModel movieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId, UserVO? userVo, bool isNowPlaying) {
    /// Movie Detail From Database
    movieModel.getMovieDetailsFromDatabase(movieId, isNowPlaying: isNowPlaying)
        .listen((movieDetail) {
          this.movieDetails = movieDetail;
          notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Get Credits By Movie
    movieModel.getCreditsByMovie(movieId).then((castAndCrew) {
      cast = castAndCrew.first ?? [];
      crew = castAndCrew[1] ?? [];
      credits = cast + crew;
      notifyListeners();
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if(!_dispose) {
      super.notifyListeners();
    }
  }
}