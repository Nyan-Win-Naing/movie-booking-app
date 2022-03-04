import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/checkout_request_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/genre_vo.dart';
import 'package:movie_booking_app/data/vos/logout_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';

abstract class MovieDataAgent {
  Future<UserVO?> postUserRegistration(String name, String email, String phone, String password, String? googleToken, String? facebookToken);
  // void getUserAuthentication(String name, String email, String phone, String password);
  Future<UserVO?> postUserLogin(String email, String password);
  Future<UserVO?> postUserLoginGoogle(String gToken);
  Future<UserVO?> postUserLoginFacebook(String fbToken);
  Future<LogoutVO?> postLogout(String token);
  Future<List<MovieVO>?> getNowPlayingMovies(int page);
  Future<List<MovieVO>?> getUpcomingMovies(int page);
  Future<List<GenreVO>?> getGenres();
  Future<MovieVO?> getMovieDetails(int movieId);
  Future<List<List<ActorVO>?>> getCreditsByMovie(int movieId);
  Future<List<CinemaVO>?> getCinema(String token, String movieId, String movieDate);
  Future<List<CinemaSeatVO>?> getCinemaSeats(String token, String timeSlotId, String bookingDate);
  Future<List<SnackVO>?> getSnacks(String token);
  Future<List<PaymentMethodVO>?> getPaymentMethods(String token);
  Future<UserVO?> getProfile(String token);
  Future<List<CardVO>?> postCreateCard(String token, String cardNumber, String cardHolder, String expireDate, String cvc);
  Future<VoucherVO?> postVoucher(String token, CheckoutRequest checkoutRequest);
  // void getCinema(String token, String movieId, String movieDate);
}