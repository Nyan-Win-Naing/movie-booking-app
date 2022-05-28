class EnvironmentConfig {
  static const String CONFIG_THEME_COLOR = String.fromEnvironment(
    "CONFIG_THEME_COLOR",
    defaultValue: "COLOR_GALAXY_APP",
  );

  static const String CONFIG_SECONDARY_COLOR = String.fromEnvironment(
    "CONFIG_SECONDARY_THEME_COLOR",
    defaultValue: "SECONDARY_COLOR_GALAXY_APP",
  );

  static const String CONFIG_APP_TITLE = String.fromEnvironment(
    "CONFIG_APP_TITLE",
    defaultValue: "APP_TITLE_GALAXY_APP",
  );

  static const String CONFIG_ONBOARDING_IMAGE = String.fromEnvironment(
      "CONFIG_ON_BOARDING_IMAGE",
      defaultValue: "ON_BOARDING_IMAGE_GALAXY_APP",);

  static const String CONFIG_HOME_PAGE_MOVIES_VIEW = String.fromEnvironment(
    "CONFIG_HOME_PAGE_MOVIES_VIEW",
    defaultValue: "HOME_PAGE_MOVIES_VIEW_GALAXY_APP",
  );
}

/// FLAVORS

/// Galaxy App
/// flutter run --dart-define=CONFIG_THEME_COLOR=COLOR_GALAXY_APP --dart-define=CONFIG_SECONDARY_THEME_COLOR=SECONDARY_COLOR_GALAXY_APP --dart-define=CONFIG_APP_TITLE=APP_TITLE_GALAXY_APP --dart-define=CONFIG_ON_BOARDING_IMAGE=ON_BOARDING_IMAGE_GALAXY_APP --dart-define=CONFIG_HOME_PAGE_MOVIES_VIEW=HOME_PAGE_MOVIES_VIEW_GALAXY_APP

/// Movie App
/// flutter run --dart-define=CONFIG_THEME_COLOR=COLOR_MOVIE_APP --dart-define=CONFIG_SECONDARY_THEME_COLOR=SECONDARY_COLOR_MOVIE_APP --dart-define=CONFIG_APP_TITLE=APP_TITLE_MOVIE_APP --dart-define=CONFIG_ON_BOARDING_IMAGE=ON_BOARDING_IMAGE_MOVIE_APP --dart-define=CONFIG_HOME_PAGE_MOVIES_VIEW=HOME_PAGE_MOVIES_VIEW_MOVIE_APP
