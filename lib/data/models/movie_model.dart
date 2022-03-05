import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/genre_vo.dart';
import 'package:movie_booking_app/data/vos/movie_choose_date_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/snack_request.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';

abstract class MovieModel {
  // Network
  void getNowPlayingMovies();
  void getUpcomingMovies();
  Future<List<GenreVO>?> getGenres();
  // Future<MovieVO?> getMovieDetails(int movieId);
  void getMovieDetails(int movieId, bool isNowPlaying);
  Future<List<List<ActorVO>?>> getCreditsByMovie(int movieId);
  void getCinemas(String token, String movieId, String movieDate);
  Future<List<CinemaSeatVO>?> getCinemaSeats(
      String token, String timeSlotId, String bookingDate);
  // Future<List<SnackVO>?> getSnacks(String token);
  void getSnacks(String token);
  void getPaymentMethods(String token);
  Future<UserVO?> getProfile(String token);
  Future<List<CardVO>?> postCreateCard(String token, String cardNumber,
      String cardHolder, String expireDate, String cvc);
  Future<VoucherVO?> postCheckout(
    String token,
    int paymentAmount,
    UserVO? userVo,
    TimeSlotVO? timeSlotVo,
    List<CinemaSeatVO>? selectSeats,
    MovieChooseDateVO? movieDate,
    int movieId,
    CinemaVO? cinemaVo,
    List<SnackVO>? snackList,
    CardVO? cardVo,
  );

  // Database
  Stream<List<MovieVO>> getNowPlayingFromDatabase();
  Stream<List<MovieVO>> getUpcomingMoviesFromDatabase();
  Stream<MovieVO?> getMovieDetailsFromDatabase(int movieId, {bool isNowPlaying = false});
  Stream<List<SnackVO>> getSnacksFromDatabase(String token);
  Stream<List<CinemaVO>?> getCinemasFromDatabase(
      String token, String movieId, String date);
  Stream<List<PaymentMethodVO>?> getPaymentMethodsFromDatabase(String token);
  Stream<UserVO?> getProfileFromDatabase(String token);
}
