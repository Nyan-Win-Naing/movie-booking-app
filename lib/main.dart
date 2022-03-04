import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/models/user_model_impl.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_list_for_hive_vo.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/collection_vo.dart';
import 'package:movie_booking_app/data/vos/date_vo.dart';
import 'package:movie_booking_app/data/vos/genre_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/production_company_vo.dart';
import 'package:movie_booking_app/data/vos/production_country_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/spoken_language_vo.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_booking_app/pages/authentication_page.dart';
import 'package:movie_booking_app/pages/home_page.dart';
import 'package:movie_booking_app/pages/movie_choose_time_page.dart';
import 'package:movie_booking_app/pages/movie_details_page.dart';
import 'package:movie_booking_app/pages/movie_seats_page.dart';
import 'package:movie_booking_app/pages/onboarding_page.dart';
import 'package:movie_booking_app/pages/payment_form_page.dart';
import 'package:movie_booking_app/pages/payment_page.dart';
import 'package:movie_booking_app/pages/snack_page.dart';
import 'package:movie_booking_app/pages/voucher_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

void main() async {
  // RetrofitDataAgentImpl()
  // .getUserAuthentication("Kyi Pyar", "kyipyar234@gmail.com",
  // "09443104881", "892939");

  // RetrofitDataAgentImpl().postUserLogin("kyipyar34@gmail.com", "892939");

  // RetrofitDataAgentImpl().getNowPlayingMovies(1);

  await Hive.initFlutter();

  Hive.registerAdapter(CardVOAdapter());
  Hive.registerAdapter(UserVOAdapter());
  Hive.registerAdapter(MovieVOAdapter());
  Hive.registerAdapter(CollectionVOAdapter());
  Hive.registerAdapter(GenreVOAdapter());
  Hive.registerAdapter(ProductionCompanyVOAdapter());
  Hive.registerAdapter(ProductionCountryVOAdapter());
  Hive.registerAdapter(SpokenLanguageVOAdapter());
  Hive.registerAdapter(ActorVOAdapter());
  Hive.registerAdapter(DateVOAdapter());
  Hive.registerAdapter(SnackVOAdapter());
  Hive.registerAdapter(CinemaVOAdapter());
  Hive.registerAdapter(TimeSlotVOAdapter());
  Hive.registerAdapter(CinemaListForHiveVOAdapter());
  Hive.registerAdapter(PaymentMethodVOAdapter());


  await Hive.openBox<UserVO>(BOX_NAME_USER_VO);
  await Hive.openBox<MovieVO>(BOX_NAME_MOVIE_VO);
  await Hive.openBox<SnackVO>(BOX_NAME_SNACK_VO);
  // await Hive.openBox<List<CinemaVO>>(BOX_NAME_CINEMA_VO);
  await Hive.openBox<CinemaListForHiveVO>(BOX_NAME_CINEMA_VO_FOR_HIVE);
  await Hive.openBox<PaymentMethodVO>(BOX_NAME_PAYMENT_METHOD_VO);
  // RetrofitDataAgentImpl().getCinema("Bearer 4009|nx8BfQXFhIFULc8Ri0QX74Hqiah3P37mxIEIzSLs", "777270", "2022-02-11");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserModel userModel = UserModelImpl();

  /// State Variables
  UserVO? userVo;

  @override
  void initState() {
    UserVO? userVo =  userModel.findUserExistsInDatabase();
    print("User vo in main : ${userVo}");
    if(userVo != null) {
      this.userVo = userVo;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),

      // home: OnBoardingPage(),
      home: userVo != null ? HomePage(userId: userVo?.id ?? 0) : OnBoardingPage(),
    );
  }
}