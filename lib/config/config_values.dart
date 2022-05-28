import 'package:flutter/material.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/galaxy_app_cards_view.dart';
import 'package:movie_booking_app/widgets/galaxy_app_credits_view.dart';
import 'package:movie_booking_app/widgets/galaxy_app_home_screen_movies_view.dart';
import 'package:movie_booking_app/widgets/movie_app_cards_view.dart';
import 'package:movie_booking_app/widgets/movie_app_credits_view.dart';
import 'package:movie_booking_app/widgets/movie_app_home-screen_movie_view.dart';

/// Theme Color
const Map<String, Color> THEME_COLORS = {
  "COLOR_GALAXY_APP" : ON_BOARDING_BACKGROUND_COLOR,
  "COLOR_MOVIE_APP" : MOVIE_APP_THEME_COLOR,
};

/// Secondary Theme And Text Color
const Map<String, Color> SECONDARY_THEME_AND_TEXT_COLORS = {
  "SECONDARY_COLOR_GALAXY_APP" : CURRENT_PAYMENT_CARD_BACKGROUND_COLOR,
  "SECONDARY_COLOR_MOVIE_APP" : Color.fromRGBO(233, 189, 68, 1.0),
};

/// App Title
const Map<String, String> APP_TITLES = {
  "APP_TITLE_GALAXY_APP" : ON_BOARDING_WELCOME_GALAXY_TEXT,
  "APP_TITLE_MOVIE_APP" : ON_BOARDING_WELCOME_MOVIE_TEXT,
};

/// On Boarding Image
const Map<String, String> ON_BOARDING_IMAGES = {
  "ON_BOARDING_IMAGE_GALAXY_APP" : "onboarding_image.png",
  "ON_BOARDING_IMAGE_MOVIE_APP" : "movie_app_background.png",
};

/// Home Page Movies View
const Map<String, Widget> HOME_PAGE_MOVIES_VIEWS = {
  "HOME_PAGE_MOVIES_VIEW_GALAXY_APP" : GalaxyAppHomeScreenMoviesView(),
  "HOME_PAGE_MOVIES_VIEW_MOVIE_APP" : MovieAppHomeScreenMovieView(),
};

/// Detail Page Credits View
const Map<String, Widget> DETAIL_PAGE_CREDITS_VIEWS = {
  "MOVIE_CREDITS_VIEW_GALAXY_APP" : GalaxyAppCreditsView(),
  "MOVIE_CREDITS_VIEW_MOVIE_APP" : MovieAppCreditsView(),
};

/// Payment Card Page View
const Map<String, Widget> PAYMENT_PAGE_CARDS_VIEWS = {
  "PAYMENT_CARDS_VIEW_GALAXY_APP" : GalaxyAppCardsView(),
  "PAYMENT_CARDS_VIEW_MOVIE_APP" : MovieAppCardsView(),
};