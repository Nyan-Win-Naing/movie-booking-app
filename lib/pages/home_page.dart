import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:movie_booking_app/blocs/home_bloc.dart';
import 'package:movie_booking_app/config/config_values.dart';
import 'package:movie_booking_app/config/environment_config.dart';
import 'package:movie_booking_app/data/models/movie_model.dart';
import 'package:movie_booking_app/data/models/movie_model_impl.dart';
import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/models/user_model_impl.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/pages/authentication_page.dart';
import 'package:movie_booking_app/pages/movie_details_page.dart';
import 'package:movie_booking_app/persistence/daos/movie_dao.dart';
import 'package:movie_booking_app/persistence/daos/user_dao.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/show_alert_dialog.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/viewitems/movie_view.dart';
import 'package:movie_booking_app/widgets/galaxy_app_home_screen_movies_view.dart';
import 'package:movie_booking_app/widgets/movie_app_home-screen_movie_view.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final int userId;

  HomePage({required this.userId});

  List<String> menuItems = [
    "Promotion Code",
    "Select Language",
    "Terms of Service",
    "Help",
    "Rate us"
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final avatarRadius = screenHeight / 20;

    // print("User Id in home page: ${widget.userId}");
    // print("Snack List in home page: $snacks");

    return ChangeNotifierProvider(
      create: (context) => HomeBloc(userId),
      child: Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Drawer(
            child: Container(
              color: THEME_COLORS[EnvironmentConfig.CONFIG_THEME_COLOR],
              padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
              child: Column(
                children: [
                  SizedBox(height: 96),
                  Selector<HomeBloc, UserVO?>(
                    selector: (context, bloc) => bloc.userVo,
                    builder: (context, user, child) => DrawerHeaderSectionView(
                      name: user?.name ?? "",
                      email: user?.email ?? "",
                    ),
                  ),
                  SizedBox(height: MARGIN_XXLARGE),
                  Column(
                    children: menuItems.map((menu) {
                      return Container(
                        margin: EdgeInsets.only(top: MARGIN_MEDIUM_2),
                        child: ListTile(
                          leading: const Icon(
                            Icons.help,
                            size: MARGIN_XLARGE,
                            color: Colors.white,
                          ),
                          title: Text(
                            menu,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: TEXT_REGULAR_3X,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  Selector<HomeBloc, UserVO?>(
                    selector: (context, bloc) => bloc.userVo,
                    builder: (context, user, child) => GestureDetector(
                      onTap: () {
                        // userModel
                        //     .postLogout("Bearer ${userVo?.token}")
                        //     .then((logoutVo) async {
                        //   if (logoutVo?.code == 200) {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => AuthenticationPage()));
                        //     userModel.deleteUserFromDatabase(userVo!);
                        //     final AccessToken? accessToken =
                        //     await FacebookAuth.instance.accessToken;
                        //     if (accessToken != null) {
                        //       print("Facebook Account Exists.");
                        //       await FacebookAuth.instance.logOut();
                        //     }
                        //   } else {
                        //     showAlertDialog(context, "Logout Fail");
                        //   }
                        // }).catchError((error) {
                        //   debugPrint(error.toString());
                        // });
                        HomeBloc bloc =
                            Provider.of<HomeBloc>(context, listen: false);
                        bloc.onTapLogout(user?.token ?? "").then((logoutVo) {
                          if (logoutVo?.code == 200) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthenticationPage(),
                              ),
                            );
                          } else {
                            showAlertDialog(context, "Logout Fail");
                          }
                        }).catchError((error) {
                          debugPrint(error.toString());
                        });
                      },
                      child: Container(
                        child: const ListTile(
                          leading: Icon(
                            Icons.logout,
                            size: MARGIN_XLARGE,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Log out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: TEXT_REGULAR_3X,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MARGIN_XLARGE),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: MARGIN_MEDIUM_2, right: MARGIN_MEDIUM),
                child: Image.asset(
                  "assets/menu_icon.png",
                ),
              ),
            );
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: MARGIN_MEDIUM_2,
                bottom: MARGIN_MEDIUM_2,
                right: MARGIN_LARGE,
              ),
              child: Image.asset(
                "assets/magnifiying-glass.png",
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Selector<HomeBloc, UserVO?>(
                  selector: (context, bloc) => bloc.userVo,
                  builder: (context, user, child) =>
                      HiSectionView(
                        avatarRadius: avatarRadius,
                        uName: user?.name ?? "",
                      ),
                ),
                const SizedBox(height: MARGIN_CARD_MEDIUM_2),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Selector<HomeBloc, List<MovieVO>>(
                //       selector: (context, bloc) => bloc.getNowPlayingMovies ?? [],
                //       builder: (context, nowPlayingMovies, child) =>
                //           Selector<HomeBloc, UserVO?>(
                //             selector: (context, bloc) => bloc.userVo,
                //             builder: (context, user, child)  =>
                //                 MovieListSectionView(
                //                   title: HOME_PAGE_NOW_SHOWING_TITLE,
                //                   onTapMovie: (movieId) => _navigateToMovieDetailsScreen(
                //                       context, movieId, user, true),
                //                   movies: nowPlayingMovies,
                //                 ),
                //           ),
                //     ),
                //     const SizedBox(height: MARGIN_MEDIUM_2),
                //     Selector<HomeBloc, List<MovieVO>>(
                //       selector: (context, bloc) => bloc.getUpcomingMovies ?? [],
                //       builder: (context, getUpcomingMovies, child) =>
                //           Selector<HomeBloc, UserVO?>(
                //             selector: (context, bloc) => bloc.userVo,
                //             builder: (context, userVo, child) =>
                //                 MovieListSectionView(
                //                   title: HOME_PAGE_COMING_SOON_TITLE,
                //                   onTapMovie: (movieId) => _navigateToMovieDetailsScreen(
                //                       context, movieId, userVo, false),
                //                   movies: getUpcomingMovies,
                //                 ),
                //           ),
                //     ),
                //   ],
                // ),
                HOME_PAGE_MOVIES_VIEWS[EnvironmentConfig.CONFIG_HOME_PAGE_MOVIES_VIEW] ?? Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerHeaderSectionView extends StatelessWidget {
  final String name;
  final String email;

  DrawerHeaderSectionView({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: PROFILE_IAMGE_SIZE,
          height: PROFILE_IAMGE_SIZE,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              // image: AssetImage("assets/lily.jpg"),
              image: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
            ),
          ),
        ),
        const SizedBox(width: MARGIN_MEDIUM_2),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_REGULAR_3X,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: MARGIN_MEDIUM),
              Wrap(
                children: [
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: MARGIN_LARGE),
                  const Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HiSectionView extends StatelessWidget {
  const HiSectionView({
    Key? key,
    required this.avatarRadius,
    required this.uName,
  }) : super(key: key);

  final double avatarRadius;
  final String uName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM_2),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            // backgroundImage: const AssetImage("assets/lily.jpg"),
            backgroundImage: const NetworkImage(
                "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG.png"),
          ),
          const SizedBox(width: MARGIN_LARGE),
          Text(
            "Hi ${uName}!",
            style: const TextStyle(
              color: Colors.black,
              fontSize: TEXT_HEADING_2X,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
