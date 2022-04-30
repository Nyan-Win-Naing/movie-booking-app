import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/blocs/authentication_bloc.dart';
import 'package:movie_booking_app/data/models/user_model.dart';
import 'package:movie_booking_app/data/models/user_model_impl.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/pages/home_page.dart';
import 'package:movie_booking_app/resources/auth_tab.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/show_alert_dialog.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/common_button_view.dart';
import 'package:movie_booking_app/widgets/form_style_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();

  late String email;
  late String password;
  late String name;
  late String phone;

  AuthTab authTab = AuthTab();

  String? getMail;
  String? getName;
  String? gToken;
  String? fbToken;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationBloc(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: MARGIN_XXLARGE * 2),
                WelcomeTitleView(),
                const SizedBox(height: MARGIN_XLARGE),
                AuthenticationInfoView(
                  emailTextController: emailTextController,
                  passwordTextController: passwordTextController,
                  nameTextController: nameTextController,
                  phoneTextController: phoneTextController,
                  authTab: authTab,
                  refreshTabIndex: (tabIndex) {
                    setState(() {});
                  },
                  email: getMail,
                  name: getName,
                ),
                const SizedBox(height: MARGIN_XLARGE),
                Builder(builder: (context) {
                  AuthenticationBloc authBloc =
                      Provider.of(context, listen: false);
                  return AuthenticationButtonSectionView(
                    onTapConfirm: () {
                      if (authTab.tabIndex == 0) {
                        email = emailTextController.text;
                        password = passwordTextController.text;
                        if (email != "" && password != "") {
                          AuthenticationBloc bloc =
                              Provider.of(context, listen: false);
                          bloc.onTapLogin(email, password).then((userVo) {
                            if (userVo != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(userId: userVo.id ?? 0),
                                ),
                              );
                            } else {
                              showAlertDialog(context,
                                  "Please check your email or password!");
                            }
                          }).catchError((error) {
                            debugPrint(error.toString());
                          });
                        }
                      } else {
                        email = emailTextController.text;
                        password = passwordTextController.text;
                        name = nameTextController.text;
                        phone = phoneTextController.text;
                        if (email.isNotEmpty &&
                            password.isNotEmpty &&
                            name.isNotEmpty &&
                            phone.isNotEmpty) {
                          print(
                              "$name, $email, $phone, $password, $gToken, $fbToken");
                          AuthenticationBloc bloc =
                              Provider.of(context, listen: false);
                          bloc
                              .onTapSignUp(
                                  name, email, phone, password, gToken, fbToken)
                              .then((user) {
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(userId: user.id ?? 0),
                                ),
                              );
                            }
                          }).catchError((error) {
                            showAlertDialog(context,
                                "This email or phone is already exists.");
                          });
                        }
                      }
                    },
                    authTabIndex: authTab.tabIndex,
                    refreshGoogleLogin: (email, name, token) {
                      setState(() {
                        getMail = email;
                        getName = name;
                        gToken = token;
                      });
                    },
                    refreshFacebookLogin: (email, name, token) {
                      setState(() {
                        getMail = email;
                        getName = name;
                        fbToken = token;
                      });
                    },
                    authBloc: authBloc,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthenticationInfoView extends StatefulWidget {
  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;
  TextEditingController? nameTextController;
  TextEditingController? phoneTextController;

  AuthTab authTab;
  Function(int) refreshTabIndex;
  String? email;
  String? name;

  AuthenticationInfoView(
      {this.emailTextController,
      this.passwordTextController,
      this.nameTextController,
      this.phoneTextController,
      required this.authTab,
      required this.refreshTabIndex,
      this.email,
      this.name});

  @override
  State<AuthenticationInfoView> createState() => _AuthenticationInfoViewState();
}

class _AuthenticationInfoViewState extends State<AuthenticationInfoView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: DefaultTabController(
            length: 2,
            child: TabBar(
              indicatorColor: ON_BOARDING_BACKGROUND_COLOR,
              indicatorWeight: 3.0,
              unselectedLabelColor: UNSELECTED_TAB_BAR_LABEL_COLOR,
              labelColor: ON_BOARDING_BACKGROUND_COLOR,
              tabs: const [
                Tab(
                  child: Text(
                    LOG_IN_TEXT,
                    style: TextStyle(
                      fontSize: TEXT_REGULAR_2X,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    SIGN_IN_TEXT,
                    style: TextStyle(
                      fontSize: TEXT_REGULAR_2X,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              onTap: (int index) {
                // setState(() {
                widget.authTab.tabIndex = index;
                widget.refreshTabIndex(widget.authTab.tabIndex);
                // });
              },
            ),
          ),
        ),
        const SizedBox(height: MARGIN_XXLARGE),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: widget.authTab.tabIndex == 0
              ? AuthenticationFormView(
                  emailTextController: widget.emailTextController,
                  passwordTextController: widget.passwordTextController,
                  email: "",
                  name: "",
                )
              : AuthenticationFormView(
                  isSignIn: true,
                  emailTextController: widget.emailTextController,
                  passwordTextController: widget.passwordTextController,
                  nameTextController: widget.nameTextController,
                  phoneTextController: widget.phoneTextController,
                  email: widget.email ?? "",
                  name: widget.name ?? "",
                ),
        ),
      ],
    );
  }
}

class AuthenticationFormView extends StatelessWidget {
  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;
  TextEditingController? nameTextController;
  TextEditingController? phoneTextController;

  final bool isSignIn;
  String name;
  String email;

  AuthenticationFormView(
      {this.isSignIn = false,
      this.emailTextController,
      this.passwordTextController,
      this.nameTextController,
      this.phoneTextController,
      required this.email,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormStyleView(
          "Email",
          "Enter your email",
          textController: emailTextController?..text = email,
          keyName: "email-field-key",
        ),
        const SizedBox(height: MARGIN_XXLARGE),
        FormStyleView(
          "Password",
          "Enter password",
          textController: passwordTextController,
          isPasswordField: true,
          keyName: "password-field-key",
        ),
        const SizedBox(height: MARGIN_MEDIUM_2),
        Visibility(
          visible: isSignIn,
          child: Column(
            children: [
              FormStyleView(
                "Name",
                "Enter your name",
                textController: nameTextController?..text = name,
              ),
              const SizedBox(height: MARGIN_XXLARGE),
              FormStyleView(
                "Phone Number",
                "Enter your phone",
                textController: phoneTextController,
                isNumber: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthenticationButtonSectionView extends StatelessWidget {
  final Function onTapConfirm;
  final int authTabIndex;
  final Function(String, String, String) refreshGoogleLogin;
  final Function(String, String, String) refreshFacebookLogin;
  final AuthenticationBloc authBloc;

  AuthenticationButtonSectionView({
    required this.onTapConfirm,
    required this.authTabIndex,
    required this.refreshGoogleLogin,
    required this.refreshFacebookLogin,
    required this.authBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
        bottom: MARGIN_MEDIUM_2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "Forgot Password ?",
            style: TextStyle(
              color: SUBSCRIPTION_TEXT_COLOR,
            ),
          ),
          const SizedBox(height: MARGIN_MEDIUM_3),
          GestureDetector(
            onTap: () async {
              if (authTabIndex == 0) {
                final LoginResult result = await FacebookAuth.instance.login(
                  permissions: ['public_profile', 'email'],
                );
                if (result.status == LoginStatus.success) {
                  final userData =
                      await FacebookAuth.i.getUserData(fields: "name, email");
                  print(
                      "Facebook Log In User data ${userData["name"]}, ${userData["email"]}, ${userData["id"]}");
                  authBloc.onTapLoginWithFacebook(userData["id"]).then((user) {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(userId: user.id ?? 0),
                        ),
                      );
                    }
                  }).catchError((error) {
                    debugPrint(error.toString());
                    showAlertDialog(context, "Facebook Login Fail!");
                  });
                }
              } else {
                final LoginResult result = await FacebookAuth.instance.login(
                  permissions: ['public_profile', 'email'],
                );
                if (result.status == LoginStatus.success) {
                  final userData =
                      await FacebookAuth.i.getUserData(fields: "name, email");
                  print(
                      "Facebook Sign In User data ${userData["name"]}, ${userData["email"]}, ${userData["id"]}");
                  refreshFacebookLogin(
                    userData["email"],
                    userData["name"],
                    userData["id"],
                  );
                } else {
                  print("Facebook sign in error status: ${result.status}");
                  print("Facebook sign in error message: ${result.message}");
                  showAlertDialog(
                      context, "Facebook Sign in is something wrong!");
                }
              }
            },
            child:
                FormButtonView("assets/facebook.png", "Sign in with facebook"),
          ),
          const SizedBox(height: MARGIN_CARD_MEDIUM_2),
          GestureDetector(
            onTap: () {
              if (authTabIndex == 0) {
                GoogleSignIn _googleSignIn = GoogleSignIn(
                  scopes: [
                    "email",
                    "https://www.googleapis.com/auth/contacts.readonly"
                  ],
                );

                _googleSignIn.signIn().then((googleAccount) {
                  googleAccount?.authentication.then((authentication) {
                    print(
                        "Google access token Login: ${authentication.accessToken}");
                    print("Google Account ID: ${googleAccount.id}");
                    authBloc
                        .onTapLoginWithGoogle(googleAccount.id)
                        .then((user) {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(userId: user.id ?? 0),
                          ),
                        );
                      } else {
                        showAlertDialog(context, "Google LogIn Fail");
                      }
                    });
                  });
                });
              } else {
                GoogleSignIn _googleSignIn = GoogleSignIn(
                  scopes: [
                    "email",
                    "https://www.googleapis.com/auth/contacts.readonly"
                  ],
                );

                _googleSignIn.signIn().then((googleAccount) {
                  googleAccount?.authentication.then((authentication) {
                    print(
                        "Google access token Sign in: ${authentication.accessToken}");
                    print("Account ID: ${googleAccount.id}");
                    refreshGoogleLogin(
                      googleAccount.email,
                      googleAccount.displayName ?? "",
                      // authentication.accessToken ?? "",
                      googleAccount.id,
                    );
                  });
                });
              }
            },
            child: FormButtonView("assets/google.png", "Sign in with google"),
          ),
          const SizedBox(height: MARGIN_CARD_MEDIUM_2),
          CommonButtonView(
            "Confirm",
            () {
              onTapConfirm();
            },

          ),
        ],
      ),
    );
  }
}

class FormButtonView extends StatelessWidget {
  final String imageName;
  final String btnLabel;

  FormButtonView(this.imageName, this.btnLabel);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MARGIN_XXLARGE + 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        border: Border.all(
          color: AUTHENTICATION_BUTTON_BORDER_COLOR,
          width: 3,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageName,
              height: 25,
            ),
            const SizedBox(width: MARGIN_MEDIUM_2),
            Text(
              btnLabel,
              style: const TextStyle(
                color: AUTHENTICATION_BUTTON_TEXT_COLOR,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeTitleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            WELCOME_TITLE,
            style: TextStyle(
              color: Colors.black,
              fontSize: TEXT_HEADING_2X,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MARGIN_MEDIUM),
          Text(
            AUTHENTICATION_LOGTIN_TITLE_TEXT,
            style: TextStyle(
              color: SUBSCRIPTION_TEXT_COLOR,
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
        ],
      ),
    );
  }
}
