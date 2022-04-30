import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
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
import 'package:movie_booking_app/main.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

import 'test_data/test_data.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
  await Hive.openBox<CinemaListForHiveVO>(BOX_NAME_CINEMA_VO_FOR_HIVE);
  await Hive.openBox<PaymentMethodVO>(BOX_NAME_PAYMENT_METHOD_VO);

  testWidgets(
    "Movie Booking App Test",
    (WidgetTester tester) async {
      Finder emailFieldKey = find.byKey(Key(EMAIL_TEXT_FIELD_KEY_NAME));
      Finder passwordFieldKey = find.byKey(Key(PASSWORD_TEXT_FIELD_KEY_NAME));

      await tester.pumpWidget(MyApp());
      await Future.delayed(Duration(seconds: 2));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byKey(Key(ON_BOARDING_BUTTON_KEY_NAME)), findsOneWidget);
      await tester.tap(find.byKey(Key(ON_BOARDING_BUTTON_KEY_NAME)));

      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(emailFieldKey, TEST_DATA_EMAIL);
      await tester.enterText(passwordFieldKey, TEST_DATA_PASSWORD);

    },
  );
}
