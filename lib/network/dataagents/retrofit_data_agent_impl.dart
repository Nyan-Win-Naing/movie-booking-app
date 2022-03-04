import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/network/dataagents/movie_data_agent.dart';
import 'package:movie_booking_app/network/responses/get_snack_list_response.dart';
import 'package:movie_booking_app/network/responses/payment_method_response.dart';
import 'package:movie_booking_app/network/the_movie_api.dart';
import 'package:movie_booking_app/network/user_api.dart';

class RetrofitDataAgentImpl extends MovieDataAgent {
  late UserApi userApi;
  late TheMovieApi movieApi;

  static final RetrofitDataAgentImpl _singleton =
      RetrofitDataAgentImpl._internal();

  factory RetrofitDataAgentImpl() {
    return _singleton;
  }

  RetrofitDataAgentImpl._internal() {
    final dio = Dio();
    userApi = UserApi(dio);
    movieApi = TheMovieApi(dio);
  }

  @override
  Future<UserVO?> postUserRegistration(String name, String email, String phone,
      String password, String? googleToken, String? facebookToken) {
    return userApi
        .postUserRegistration(
            name, email, phone, password, googleToken, facebookToken)
        .asStream()
        .map((response) {
      UserVO? userVo = response.data;
      userVo?.token = response.token;
      return userVo;
    }).first;
  }

  @override
  Future<UserVO?> postUserLogin(String email, String password) {
    return userApi.postUserLogin(email, password).asStream().map((response) {
      UserVO? userVo = response.data;
      userVo?.token = response.token;
      return userVo;
    }).first;
  }

  @override
  Future<UserVO?> postUserLoginGoogle(String gToken) {
    return userApi.postUserLoginWithGoogle(gToken).asStream().map((response) {
      UserVO? userVo = response.data;
      userVo?.token = response.token;
      return userVo;
    }).first;
  }

  @override
  Future<UserVO?> postUserLoginFacebook(String fbToken) {
    return userApi
        .postUserLoginWithFacebook(fbToken)
        .asStream()
        .map((response) {
      UserVO? userVo = response.data;
      userVo?.token = response.token;
      return userVo;
    }).first;
  }

  @override
  Future<List<MovieVO>?> getNowPlayingMovies(int page) {
    return movieApi
        .getNowPlayingMovies(API_KEY, LANGUAGE_EN_US, page.toString())
        .asStream()
        .map((response) {
      // print(response.toString());
      return response.results;
    }).first;
  }

  @override
  Future<List<MovieVO>?> getUpcomingMovies(int page) {
    return movieApi
        .getUpcomingMovies(API_KEY, LANGUAGE_EN_US, page.toString())
        .asStream()
        .map((response) => response.results)
        .first;
  }

  @override
  Future<LogoutVO?> postLogout(String token) {
    return userApi.logout(token);
  }

  @override
  Future<List<GenreVO>?> getGenres() {
    return movieApi
        .getGenres(API_KEY, LANGUAGE_EN_US)
        .asStream()
        .map((response) => response.genres)
        .first;
  }

  @override
  Future<MovieVO?> getMovieDetails(int movieId) {
    return movieApi.getMovieDetails(
        movieId.toString(), API_KEY, LANGUAGE_EN_US);
  }

  @override
  Future<List<List<ActorVO>?>> getCreditsByMovie(int movieId) {
    return movieApi
        .getCreditsByMovie(movieId.toString(), API_KEY, LANGUAGE_EN_US)
        .asStream()
        .map(
          (getCreditsByMovieResponse) =>
              [getCreditsByMovieResponse.cast, getCreditsByMovieResponse.crew],
        )
        .first;
  }

  @override
  Future<List<CinemaVO>?> getCinema(
      String token, String movieId, String movieDate) {
    print(
        "Retrofit Impl token: $token, movieID: $movieId, movieDate: $movieDate");

    return userApi
        .getTimeSlotResponse(token, "application/json", movieId, movieDate)
        .asStream()
        .map((timeSlotResponse) {
      print("Code: ${timeSlotResponse.code}");
      return timeSlotResponse.results;
    }).first;
  }

  @override
  Future<List<CinemaSeatVO>?> getCinemaSeats(
      String token, String timeSlotId, String bookingDate) {
    return userApi
        .getSeatingPlanResponse(token, timeSlotId, bookingDate)
        .asStream()
        .map((seatPlanResponse) {
      return seatPlanResponse.seatData?.expand((seat) => seat).toList();
    }).first;
  }

  @override
  Future<List<SnackVO>?> getSnacks(String token) {
    return userApi
        .getSnackListResponse(token)
        .asStream()
        .map((snackListResponse) {
      GetSnackListResponse sr = snackListResponse;
      print("Snack Retrofit response code: ${sr.code}");
      sr.data?.forEach((element) {
        element.quantity = 0;
      });
      return snackListResponse.data;
    }).first;
  }

  @override
  Future<List<PaymentMethodVO>?> getPaymentMethods(String token) {
    return userApi
        .getPaymentMethodResponse(token)
        .asStream()
        .map((paymentResponse) {
      PaymentMethodResponse pr = paymentResponse;
      pr.data?.forEach((element) {
        element.isSelected = false;
      });
      return paymentResponse.data;
    }).first;
  }

  @override
  Future<UserVO?> getProfile(String token) {
    return userApi
        .getProfileResponse(token)
        .asStream()
        .map((authResponse) => authResponse.data)
        .first;
  }

  @override
  Future<List<CardVO>?> postCreateCard(String token, String cardNumber,
      String cardHolder, String expireDate, String cvc) {
    print("Token: ${token}, CardNumber: ${cardNumber},"
        " CardHolder: ${cardHolder}, ExpireDate: ${expireDate}, CVC: ${cvc}");
    return userApi
        .postCreateCardResponse(token, cardNumber, cardHolder, expireDate, cvc)
        .asStream()
        .map((createCardResponse) {
      print("Code: ${createCardResponse.code}");
      return createCardResponse.data;
    }).first;
  }

  @override
  Future<VoucherVO?> postVoucher(
      String token, CheckoutRequest checkoutRequest) {
    print(token);
    print(checkoutRequest);
    return userApi
        .postCheckout(token, checkoutRequest)
        .asStream()
        .map((checkoutResponse) {
      print("Checkout Response Code: ${checkoutResponse.code}");
      print("Checkout Response Message: ${checkoutResponse.message}");
      return checkoutResponse.voucherVo;
    }).first;
  }

  // @override
  // void getUserAuthentication(
  //     String name, String email, String phone, String password) {
  //   userApi
  //       .getUserAuthentication(name, email, phone, password)
  //       .then((value) =>
  //           debugPrint("Authentication Resoponse ===> ${value.toString()}"))
  //       .catchError((error) => debugPrint("Error ===> ${error.toString()}"));
  // }
}
