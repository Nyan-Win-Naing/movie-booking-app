import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/models/user_model_impl.dart';
import 'package:movie_booking_app/data/vos/logout_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';

class HomeBloc extends ChangeNotifier {
  /// States
  UserVO? userVo;
  List<MovieVO>? getNowPlayingMovies;
  List<MovieVO>? getUpcomingMovies;

  /// Model
  MovieModel movieModel = MovieModelImpl();
  UserModel userModel = UserModelImpl();

  HomeBloc(int userId) {
    /// Get User From Database
    userModel.getUserByIdFromDatabase(userId).listen((userVo) {
      this.userVo = userVo;
      notifyListeners();
      movieModel.getSnacks(userVo?.token ?? "");
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Now Playing Movies from Database
    movieModel.getNowPlayingFromDatabase().listen((movieList) {
      this.getNowPlayingMovies = movieList;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Upcoming Movies From Database
    movieModel.getUpcomingMoviesFromDatabase().listen((movieList) {
      this.getUpcomingMovies = movieList;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });
  }

  Future<LogoutVO?> onTapLogout(String userToken) {
    return userModel.postLogout(userToken).then((logoutVo) async {
      userModel.deleteUserFromDatabase(this.userVo!);
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        print("Facebook Account Exists.");
        await FacebookAuth.instance.logOut();
      }
      return Future.value(logoutVo);
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }
}
