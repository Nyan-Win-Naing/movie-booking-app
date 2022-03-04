import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
import 'package:movie_booking_app/widgets/title_text.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Model Object
  MovieModel movieModel = MovieModelImpl();
  UserModel userModel = UserModelImpl();

  /// State Variables
  UserVO? userVo;
  List<MovieVO>? getNowPlayingMovies;
  List<MovieVO>? getUpcomingMovies;
  // List<SnackVO>? snacks;

  @override
  void initState() {
    /// Get User From Database
    userModel.getUserByIdFromDatabase(widget.userId).listen((userVo) {
      setState(() {
        this.userVo = userVo;
        print("User vo in Home set state is $userVo");
        // movieModel.getSnacks("Bearer ${userVo?.token}").then((snackList) {
        //   print("Snack List is $snackList");
        //   snacks = snackList;
        // }).catchError((error) {
        //   debugPrint(error.toString());
        // });
        movieModel.getSnacks("${userVo?.token}");
      });
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Now Playing Movies
    // movieModel.getNowPlayingMovies().then((movieList) {
    //   setState(() {
    //     getNowPlayingMovies = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Now Playing Movies Database
    movieModel.getNowPlayingFromDatabase().listen((movieList) {
      setState(() {
        getNowPlayingMovies = movieList;
      });
    }).onError((error) {
      debugPrint(error.toString());
    });

    /// Upcoming Moviese
    // movieModel.getUpcomingMovies().then((movieList) {
    //   setState(() {
    //     getUpcomingMovies = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Upcoming Movies Database
    movieModel.getUpcomingMoviesFromDatabase().listen((movieList) {
      setState(() {
        getUpcomingMovies = movieList;
      });
    }).onError((error) {
      debugPrint(error.toString());
    });

    super.initState();
  }

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

    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
          child: Container(
            color: ON_BOARDING_BACKGROUND_COLOR,
            padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
            child: Column(
              children: [
                SizedBox(height: 96),
                DrawerHeaderSectionView(
                  name: userVo?.name ?? "",
                  email: userVo?.email ?? "",
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
                GestureDetector(
                  onTap: () {
                    userModel
                        .postLogout("Bearer ${userVo?.token}")
                        .then((logoutVo) async {
                      if (logoutVo?.code == 200) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthenticationPage()));
                        userModel.deleteUserFromDatabase(userVo!);
                        final AccessToken? accessToken =
                            await FacebookAuth.instance.accessToken;
                        if (accessToken != null) {
                          print("Facebook Account Exists.");
                          await FacebookAuth.instance.logOut();
                        }
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
              HiSectionView(
                avatarRadius: avatarRadius,
                uName: userVo?.name ?? "",
              ),
              const SizedBox(height: MARGIN_CARD_MEDIUM_2),
              MovieListSectionView(
                title: HOME_PAGE_NOW_SHOWING_TITLE,
                onTapMovie: (movieId) =>
                    _navigateToMovieDetailsScreen(context, movieId, userVo),
                movies: getNowPlayingMovies,
              ),
              const SizedBox(height: MARGIN_MEDIUM_2),
              MovieListSectionView(
                title: HOME_PAGE_COMING_SOON_TITLE,
                onTapMovie: (movieId) =>
                    _navigateToMovieDetailsScreen(context, movieId, userVo),
                movies: getUpcomingMovies,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMovieDetailsScreen(
      BuildContext context, int? movieId, UserVO? userVo) {
    if (movieId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(
            movieId: movieId,
            userVo: userVo,
          ),
        ),
      );
    }
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

class MovieListSectionView extends StatelessWidget {
  final String title;
  final Function(int?) onTapMovie;
  final List<MovieVO>? movies;

  MovieListSectionView({
    required this.title,
    required this.onTapMovie,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
          child: TitleText(title),
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        HorizontalMovieListView(
          onTapMovie: (movieId) => this.onTapMovie(movieId),
          movieList: movies,
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final Function(int?) onTapMovie;
  final List<MovieVO>? movieList;

  HorizontalMovieListView({
    required this.onTapMovie,
    required this.movieList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_VIEW_HEIGHT,
      child: (movieList != null)
          ? ListView.builder(
              padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
              scrollDirection: Axis.horizontal,
              itemCount: movieList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => onTapMovie(movieList?[index].id),
                  child: MovieView(
                    movie: movieList?[index],
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
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
            backgroundImage: NetworkImage(
                "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
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
