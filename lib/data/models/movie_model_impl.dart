import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/checkout_request_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_list_for_hive_vo.dart';
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
import 'package:movie_booking_app/network/dataagents/movie_data_agent.dart';
import 'package:movie_booking_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_booking_app/persistence/daos/cinema_dao.dart';
import 'package:movie_booking_app/persistence/daos/movie_dao.dart';
import 'package:movie_booking_app/persistence/daos/payment_method_dao.dart';
import 'package:movie_booking_app/persistence/daos/snack_dao.dart';
import 'package:movie_booking_app/persistence/daos/user_dao.dart';
import 'package:stream_transform/stream_transform.dart';

class MovieModelImpl extends MovieModel {
  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl() {
    return _singleton;
  }

  MovieModelImpl._internal();

  /// Data agent
  final MovieDataAgent _dataAgent = RetrofitDataAgentImpl();

  /// Daos
  MovieDao mMovieDao = MovieDao();
  SnackDao mSnackDao = SnackDao();
  CinemaDao mCinemaDao = CinemaDao();
  PaymentMethodDao mPaymentMethodDao = PaymentMethodDao();
  UserDao userDao = UserDao();

  /// Get Bearer Token String
  String getBearerToken(String token) {
    return "Bearer $token";
  }

  // Network
  @override
  void getNowPlayingMovies() {
    _dataAgent.getNowPlayingMovies(1).then((movies) async {
      List<MovieVO>? nowPlayingMovies = movies?.map((movie) {
        movie.isNowPlaying = true;
        movie.isUpComing = false;
        return movie;
      }).toList();

      mMovieDao.saveMovies(nowPlayingMovies);
    });
  }

  @override
  void getUpcomingMovies() {
    _dataAgent.getUpcomingMovies(1).then((movies) async {
      List<MovieVO>? upcomingMovies = movies?.map((movie) {
        movie.isNowPlaying = false;
        movie.isUpComing = true;
        return movie;
      }).toList();
      mMovieDao.saveMovies(upcomingMovies);
    });
  }

  @override
  Future<List<GenreVO>?> getGenres() {
    return _dataAgent.getGenres();
  }

  @override
  void getMovieDetails(int movieId, bool isNowPlaying) {
    // return _dataAgent.getMovieDetails(movieId).then((movie) async {
    //   mMovieDao.saveSingleMovie(movie);
    //   return Future.value(movie);
    // });
    _dataAgent.getMovieDetails(movieId).then((movie) async {
      if(isNowPlaying == true)
        movie?.isNowPlaying = true;
      else
        movie?.isUpComing = true;
      mMovieDao.saveSingleMovie(movie);
      // return Future.value(movie);
    });
  }

  @override
  Future<List<List<ActorVO>?>> getCreditsByMovie(int movieId) {
    return _dataAgent.getCreditsByMovie(movieId);
  }

  @override
  void getCinemas(String token, String movieId, String movieDate) {
    _dataAgent.getCinema(token, movieId, movieDate).then((cinemas) {
      CinemaListForHiveVO cListHive = CinemaListForHiveVO(cinemas);
      mCinemaDao.saveCinemas(movieDate, cListHive);
    });
  }

  @override
  Future<List<CinemaSeatVO>?> getCinemaSeats(
      String token, String timeSlotId, String bookingDate) {
    return _dataAgent.getCinemaSeats(getBearerToken(token), timeSlotId, bookingDate);
  }

  // @override
  // Future<List<SnackVO>?> getSnacks(String token) {
  //   print("Movie model impl: $token");
  //   if (token == "Bearer ") {
  //     return Future.value([]);
  //   } else {
  //     return _dataAgent.getSnacks(token).then((snacks) async {
  //       mSnackDao.saveSnacks(snacks);
  //       return Future.value(snacks);
  //     });
  //   }
  //   // return _dataAgent.getSnacks(token);
  // }

  @override
  void getSnacks(String token) {
    if (token == "") {
      print("Token is Empty");
    } else {
      print("Else block token is : $token.........");
      _dataAgent.getSnacks(getBearerToken(token)).then((snacks) async {
        mSnackDao.saveSnacks(snacks);
      });
    }
  }

  @override
  void getPaymentMethods(String token) {
    // return _dataAgent.getPaymentMethods(token);
    _dataAgent.getPaymentMethods(token).then((paymentMethods) async {
      mPaymentMethodDao.savePaymentMethods(paymentMethods);
    });
  }

  @override
  Future<UserVO?> getProfile(String token) {
    return _dataAgent.getProfile(token).then((userVo) async {
      userDao.deleteUser(userVo);
      userVo?.token = token.substring(7);
      userDao.saveUser(userVo);
      return Future.value(userVo);
    });
    // return _dataAgent.getProfile(token);
  }

  @override
  Future<List<CardVO>?> postCreateCard(String token, String cardNumber,
      String cardHolder, String expireDate, String cvc) {
    return _dataAgent.postCreateCard(
        getBearerToken(token), cardNumber, cardHolder, expireDate, cvc);
  }

  @override
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
      CardVO? cardVo) {
    Set<String> selectedRows = {};

    selectSeats?.forEach((seat) {
      selectedRows.add(seat.symbol ?? "");
    });

    List<SnackRequest> snackRequestList = snackList?.map((snack) {
          return SnackRequest(snack.id ?? 0, snack.quantity ?? 0);
        }).toList() ??
        [];

    return _dataAgent.postVoucher(
        token,
        CheckoutRequest(
          timeSlotVo?.timeslotId ?? 0,
          selectedRows.toList().join(","),
          selectSeats?.map((s) => s.seatName).toList().join(",") ?? "",
          movieDate?.dateTime.toString().substring(0, 10) ?? "",
          paymentAmount,
          movieId,
          cardVo?.id ?? 0,
          cinemaVo?.cinemaId ?? 0,
          snackRequestList,
        ));
  }

  // Database
  @override
  Stream<List<MovieVO>> getNowPlayingFromDatabase() {
    // return Future.value(mMovieDao
    //     .getAllMovies()
    //     .where((movie) => movie.isNowPlaying ?? true)
    //     .toList());
    this.getNowPlayingMovies();
    return mMovieDao
        .getAllMovieEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovies());
  }

  @override
  Stream<List<MovieVO>> getUpcomingMoviesFromDatabase() {
    // return Future.value(mMovieDao
    //     .getAllMovies()
    //     .where((movie) => movie.isUpComing ?? true)
    //     .toList());
    this.getUpcomingMovies();
    return mMovieDao
        .getAllMovieEventStream()
        .startWith(mMovieDao.getUpcomingMoviesStream())
        .map((event) => mMovieDao.getUpcomingMovies());
  }

  @override
  Stream<MovieVO?> getMovieDetailsFromDatabase(int movieId, {bool isNowPlaying = false}) {
    this.getMovieDetails(movieId, isNowPlaying);
    // return Future.value(mMovieDao.getMovieById(movieId));
    return mMovieDao
        .getAllMovieEventStream()
        .startWith(mMovieDao.getMovieByIdStream(movieId))
        .map((event) {
      print("Movie Details From Database map function callback works...");
      return mMovieDao.getMovie(movieId);
    });
  }

  @override
  Stream<List<SnackVO>> getSnacksFromDatabase(String token) {
    // return Future.value(mSnackDao.getAllSnackList());
    this.getSnacks(token);
    return mSnackDao
        .getAllSnacksEventStream()
        .startWith(mSnackDao.getSnacksStream())
        .map((event) => mSnackDao.getSnacks());
  }

  @override
  Stream<List<CinemaVO>?> getCinemasFromDatabase(
      String token, String movieId, String date) {
    getCinemas(getBearerToken(token), movieId, date);
    // return Future.value(mCinemaDao.getCinema(date)?.cinemaList);
    return mCinemaDao
        .getCinemasEventStream()
        .startWith(mCinemaDao.getCinemasStream(date))
        .map((event) => mCinemaDao.getCinemaByDate(date)?.cinemaList);
  }

  @override
  Stream<List<PaymentMethodVO>?> getPaymentMethodsFromDatabase(String token) {
    this.getPaymentMethods(getBearerToken(token));
    return mPaymentMethodDao
        .getPaymentMethodsEventStream()
        .startWith(mPaymentMethodDao.getPaymentMethodsStream())
        .map((event) => mPaymentMethodDao.getPaymentMethods());
  }

  @override
  Stream<UserVO?> getProfileFromDatabase(String token) {
    UserVO? user;
    this.getProfile(getBearerToken(token)).then((userVo) {
      user = userVo;
    });
    return userDao
        .getUserEventStream()
        .startWith(userDao.getUserStream(user?.id ?? 0))
        .map((event) {
      return userDao.getUser(user?.id ?? 0);
    });
  }
}
