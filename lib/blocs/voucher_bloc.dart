import 'package:flutter/foundation.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';

class VoucherBloc extends ChangeNotifier {
  /// States
  VoucherVO? voucherVo;
  MovieVO? movieVo;

  /// Model
  MovieModel movieModel = MovieModelImpl();

  VoucherBloc(int movieId, VoucherVO? voucherVo) {
    /// Movie Details From Database
    movieModel.getMovieDetailsFromDatabase(movieId).listen((movie) {
      this.movieVo = movie;
      notifyListeners();
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Set Voucher State
    this.voucherVo = voucherVo;
    notifyListeners();
  }
}