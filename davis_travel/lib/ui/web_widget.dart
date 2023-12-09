import 'dart:developer';

import 'package:davis_travel/model/footer_list.dart';
import 'package:davis_travel/model/user_data.dart';
import 'package:davis_travel/repository/auth_provider.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/utils/app_helpers.dart';
import 'package:davis_travel/utils/dialogs.dart';
import 'package:davis_travel/utils/html_helpers.dart';
import 'package:davis_travel/utils/shared_helpers.dart';
import 'package:davis_travel/widget/button_widget.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HeaderWidget extends StatefulWidget {
  final Widget mainWidget;
  final bool? isStay;

  const HeaderWidget({super.key, required this.mainWidget, this.isStay});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  double opacityTitle = 0;

  Locale? languange = const Locale('en', 'US');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserData? userAuth;
  bool isSignOut = false;

  double paddingLogin = 8;
  double paddingRegister = 8;

  bool isOpen = false;

  final locales = [
    {
      'flag': '🇺🇸',
      'name': 'English',
      'locale': const Locale('en', 'US'),
    },
    {
      'flag': '🇯🇵',
      'name': 'Japanese',
      'locale': const Locale('ja', 'JP'),
    },
    {
      'flag': '🇮🇩',
      'name': 'Bahasa Indonesia',
      'locale': const Locale('id', 'ID'),
    },
  ];

  bool isTablet = true;

  @override
  void initState() {
    initLanguage();
    super.initState();
    opacityTitle = (widget.isStay ?? false) ? 1 : 0;
    initUser();
  }

  void initUser() async {
    await AuthProvider.getProfile().then((value) async {
      if (value != null) {
        setState(() {
          userAuth = value;
        });
      } else {
        final listenerGoogle = await AuthProvider.profileGoogle();

        if (listenerGoogle != null) {
          listenerGoogle.listen((GoogleSignInAccount? account) async {
            print("google not found ");
            if (account == null) {
              print("user google not found ");
              setState(() {
                userAuth = null;
              });

              await AuthProvider.googleLoginSilent();
            } else {
              print("user google found ${account.email}");
              await AuthProvider.autoLoginGoogle(await account.authentication)
                  .then((result) {
                if (result != null) {
                  setState(() {
                    userAuth = result;
                  });
                }
              });

              if (isOpen) {
                Navigator.pop(context);
              }
            }
          });
        }
      }
    });
  }

  void initLanguage() async {
    String lang = await getSharedString("localeId") ?? "en";

    setState(() {
      if (lang == "ja") {
        languange = const Locale('ja', 'JP');
      } else if (lang == "id") {
        languange = const Locale('id', 'ID');
      } else {
        languange = const Locale('en', 'US');
      }

      Get.updateLocale(languange ?? const Locale('en', 'US'));
    });
  }

  @override
  Widget build(BuildContext context) {
    isTablet = getDeviceType() == "tablet";

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          endDrawer: Drawer(
            backgroundColor: colorBgGrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.viewPaddingOf(context).top + 14),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 50,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          text: "SKYFAST TOUR",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorBlack,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: languageSwitch()),
                  const SizedBox(height: 12),
                  userAuth != null
                      ? ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              CustomText(
                                text: userAuth?.displayName ?? "Anonymous",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 6),
                              CustomText(
                                text: userAuth?.email ?? "example@gmail.com",
                                fontSize: 13,
                                color: greyTextSubtitle,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                          onTap: () {},
                        )
                      : Column(
                          children: [
                            ListTile(
                                title: CustomText(text: "login".tr),
                                onTap: () {
                                  actionLogin(true);
                                }),
                            ListTile(
                                title: CustomText(text: "register".tr),
                                onTap: () {
                                  actionLogin(false);
                                }),
                          ],
                        ),
                  ListTile(
                      title: CustomText(text: "home".tr),
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed("/home");
                      }),
                  ListTile(
                      title: CustomText(text: "holiday".tr),
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed("/transport");
                      }),
                  ListTile(
                      title: CustomText(text: "about_us".tr),
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed("/profile");
                      }),
                  ListTile(
                      title: CustomText(text: "privacy".tr),
                      onTap: () {
                        Navigator.pop(context);
                        Get.toNamed("/privacy");
                      }),
                  if (userAuth != null)
                    ListTile(
                        title: CustomText(
                          text: "logout".tr,
                          color: colorRed,
                          fontWeight: FontWeight.w600,
                        ),
                        onTap: () async {
                          setState(() {
                            isSignOut = true;
                          });

                          bool? signGoogle = await getSharedBool("sign_google");

                          if (signGoogle ?? false) {
                            await AuthProvider.googleLogout();
                          }

                          await AuthProvider.logout().then((value) {
                            setState(() {
                              isSignOut = false;
                            });

                            if (value) {
                              Navigator.pop(context);

                              showAlertDialog(
                                title: 'information'.tr,
                                content: "successfully_logout".tr,
                              );
                            }
                          });
                        }),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            MediaQuery.viewPaddingOf(context).bottom + 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Copyright SKYFAST 2023",
                          fontSize: 12,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          body: (widget.isStay ?? false)
              ? Column(
                  children: [
                    home(),
                    Expanded(child: widget.mainWidget),
                  ],
                )
              : Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    NotificationListener(
                        onNotification: (ScrollMetricsNotification n) {
                          if (n.metrics.pixels < 160 && n.metrics.pixels > 0) {
                            setState(() {
                              opacityTitle = n.metrics.pixels / 160;
                            });
                          } else if (n.metrics.pixels >= 160) {
                            setState(() {
                              opacityTitle = 1;
                            });
                          } else if (n.metrics.pixels < 1) {
                            setState(() {
                              opacityTitle = 0;
                            });
                          }

                          return true;
                        },
                        child: widget.mainWidget),
                    home(),
                  ],
                ),
        ),
        if (isSignOut)
          Container(
            color: colorBlack.withOpacity(0.3),
            child: Center(
              child: CupertinoActivityIndicator(
                color: colorWhite,
              ),
            ),
          )
      ],
    );
  }

  Widget home() {
    Color colorNav = (widget.isStay ?? false)
        ? colorBlack
        : (opacityTitle > 0
            ? colorBlack.withOpacity(opacityTitle)
            : colorWhite);

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: isTablet ? 32 : 20, vertical: 20),
      decoration: BoxDecoration(
        color: colorWhite.withOpacity(opacityTitle),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorBlack.withOpacity(opacityTitle / 10),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed("/home");
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 50,
                ),
                const SizedBox(width: 6),
                CustomText(
                  text: "SKYFAST TOUR",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorNav,
                ),
              ],
            ),
          ),
          const Spacer(),
          isTablet
              ? Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed("/home");
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: colorNav,
                          ),
                          const SizedBox(width: 3),
                          CustomText(
                            text: "home".tr,
                            fontSize: 14,
                            color: colorNav,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/transport");
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.flight_takeoff_rounded,
                            color: colorNav,
                          ),
                          const SizedBox(width: 3),
                          CustomText(
                            text: "holiday".tr,
                            fontSize: 14,
                            color: colorNav,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/profile");
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.contact_page_rounded,
                            color: colorNav,
                          ),
                          const SizedBox(width: 3),
                          CustomText(
                            text: "about_us".tr,
                            fontSize: 14,
                            color: colorNav,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/privacy");
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.security_rounded,
                            color: colorNav,
                          ),
                          const SizedBox(width: 3),
                          CustomText(
                            text: "privacy".tr,
                            fontSize: 14,
                            color: colorNav,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    languageSwitch(),
                    const SizedBox(width: 10),
                    userAuth != null
                        ? Row(
                            children: [
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    text: userAuth?.displayName ?? "Anonymous",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: colorNav,
                                  ),
                                  const SizedBox(height: 6),
                                  CustomText(
                                    text:
                                        userAuth?.email ?? "example@gmail.com",
                                    fontSize: 13,
                                    color: greyTextSubtitle,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    isSignOut = true;
                                  });

                                  bool? signGoogle =
                                      await getSharedBool("sign_google");

                                  if (signGoogle ?? false) {
                                    await AuthProvider.googleLogout();
                                  }

                                  await AuthProvider.logout().then((value) {
                                    setState(() {
                                      isSignOut = false;
                                    });

                                    if (value) {
                                      showAlertDialog(
                                        title: 'information'.tr,
                                        content: "successfully_logout".tr,
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: colorRed,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: CustomText(
                                    text: "logout".tr,
                                    fontSize: 14,
                                    color: colorWhite,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  actionLogin(true);
                                },
                                onHover: (value) {
                                  if (value) {
                                    setState(() {
                                      paddingLogin = 16;
                                    });
                                  } else {
                                    setState(() {
                                      paddingLogin = 8;
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 650),
                                  curve: Curves.easeIn,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingLogin, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: opacityTitle > 0
                                          ? colorGrey.withOpacity(opacityTitle)
                                          : colorWhite,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: CustomText(
                                    text: "login".tr,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  actionLogin(false);
                                },
                                onHover: (value) {
                                  if (value) {
                                    setState(() {
                                      paddingRegister = 16;
                                    });
                                  } else {
                                    setState(() {
                                      paddingRegister = 8;
                                    });
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 650),
                                  curve: Curves.easeIn,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingRegister, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: colorBlack,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: CustomText(
                                    text: "register".tr,
                                    fontSize: 14,
                                    color: colorWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                )
              : IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  icon: Icon(
                    Icons.apps_rounded,
                    color: opacityTitle > 0 ? colorBlack : colorWhite,
                  )),
        ],
      ),
    );
  }

  Widget languageSwitch({double? horizontal}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal ?? 12),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: languange,
          icon: const Icon(Icons.expand_more_rounded),
          dropdownColor: colorWhite,
          onChanged: (Locale? value) async {
            Get.updateLocale(value!);

            await setSharedString(
                "localeId",
                value == const Locale('en', 'US')
                    ? "en"
                    : (value == const Locale('ja', 'JP') ? "ja" : "id"));

            setState(() {
              languange = value;
            });

            refresh();
          },
          items: locales.map((e) {
            return DropdownMenuItem<Locale>(
              value: e['locale'] as Locale,
              child: Row(
                children: [
                  CustomText(
                    text: e['flag'].toString(),
                    fontSize: 14,
                    padding: const EdgeInsets.only(right: 20),
                  ),
                  CustomText(
                    text: e['name'].toString(),
                    fontSize: 14,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> actionLogin(bool isLogin) async {
    isTablet = getDeviceType() == "tablet";

    bool loadLogin = false;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();

    await showCupertinoDialog(
        context: Get.context!,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (context) {
          isOpen = true;

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              content: SizedBox(
                width: isTablet ? (getWidth() / 3) : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: isLogin ? 'login'.tr : 'register'.tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colorTextPrimary,
                    ),
                    const SizedBox(height: 20),
                    if (!isLogin)
                      Column(
                        children: [
                          TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                                hintText: "first_name".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                                hintText: "last_name".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "email".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "password".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                        label: isLogin ? 'login'.tr : 'register'.tr,
                        radius: 20,
                        isLoading: loadLogin,
                        onPressed: () async {
                          if (emailController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_email".tr,
                            );
                          } else if (passwordController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_password".tr,
                            );
                          } else if (passwordController.text.length < 8) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "minimum_password".tr,
                            );
                          } else {
                            if (isLogin) {
                              setState(() {
                                loadLogin = true;
                              });

                              try {
                                await AuthProvider.login(
                                        email: emailController.text,
                                        password: passwordController.text)
                                    .then((value) async {
                                  log("Hasil login: $value");
                                  if (value != null) {
                                    if (value == "Error") {
                                      showAlertDialog(
                                        title: 'information'.tr,
                                        content: "Gagal login",
                                      );
                                    } else if (value ==
                                        "The email address is badly formatted.") {
                                      showAlertDialog(
                                        title: 'information'.tr,
                                        content: "Email tidak valid",
                                      );
                                    } else {
                                      Navigator.pop(context);

                                      showAlertDialog(
                                        title: 'information'.tr,
                                        content:
                                            "${"hello".tr} $value, ${"successfully_loggedin".tr}",
                                      );
                                    }
                                  }
                                });
                              } on FirebaseAuthException catch (e) {
                                showAlertDialog(
                                  title: 'information'.tr,
                                  content: e.message,
                                );
                              } finally {
                                setState(() {
                                  loadLogin = false;
                                });
                              }
                            } else {
                              if (firstNameController.text.isEmpty) {
                                showAlertDialog(
                                  title: 'information'.tr,
                                  content: "please_fill_first_name".tr,
                                );
                              } else if (lastNameController.text.isEmpty) {
                                showAlertDialog(
                                  title: 'information'.tr,
                                  content: "please_fill_last_name".tr,
                                );
                              } else {
                                setState(() {
                                  loadLogin = true;
                                });

                                try {
                                  await AuthProvider.register(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) async {
                                    if (value != null) {
                                      Navigator.pop(context);

                                      showAlertDialog(
                                        title: 'information'.tr,
                                        content:
                                            "${"hello".tr} $value, ${"successfully_registered".tr}",
                                      );
                                    }
                                  });
                                } on FirebaseAuthException catch (e) {
                                  showAlertDialog(
                                    title: 'information'.tr,
                                    content: e.message,
                                  );
                                } finally {
                                  setState(() {
                                    loadLogin = false;
                                  });
                                }
                              }
                            }
                          }
                        }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'forget_password'.tr,
                          fontSize: 15,
                          color: colorPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'or'.tr,
                          fontSize: 18,
                          color: greyTextSubtitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /*
                        InkWell(
                          onTap: () async {
                            setState(() {
                              loadGoogle = true;
                            });

                            await AuthProvider.googleLogin()
                                .then((value) async {
                              if (value != null) {
                                Navigator.pop(context);

                                showAlertDialog(
                                  title: 'information'.tr,
                                  content:
                                      "${"hello".tr} $value, ${"successfully_loggedin".tr}",
                                );
                              }

                              setState(() {
                                loadGoogle = false;
                              });
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: greyTextSubtitle)),
                            child: loadGoogle
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/google_logo.png',
                                        fit: BoxFit.cover,
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      const CustomText(
                                        text: 'Google',
                                        fontSize: 17,
                                        color: greyTextSubtitle,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        */

                        AuthProvider.buildSignInButton(),
                      ],
                    ),
                    /*
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: greyTextSubtitle)),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/google_logo.png',
                                fit: BoxFit.cover,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 5),
                              const CustomText(
                                text: 'Google',
                                fontSize: 17,
                                color: greyTextSubtitle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: greyTextSubtitle)),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/facebook_logo.png',
                                fit: BoxFit.cover,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 5),
                              const CustomText(
                                text: 'Facebook',
                                fontSize: 17,
                                color: greyTextSubtitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    */
                    const SizedBox(height: 20),
                    isLogin
                        ? InkWell(
                            onTap: () {
                              Get.back();

                              actionLogin(false);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'just_created_account'.tr,
                                  fontSize: 15,
                                  color: greyTextSubtitle,
                                ),
                                const SizedBox(width: 5),
                                CustomText(
                                  text: 'register'.tr,
                                  fontSize: 15,
                                  color: colorPrimary,
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Get.back();

                              actionLogin(true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'have_account'.tr,
                                  fontSize: 15,
                                  color: greyTextSubtitle,
                                ),
                                const SizedBox(width: 5),
                                CustomText(
                                  text: 'login'.tr,
                                  fontSize: 15,
                                  color: colorPrimary,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            );
          });
        }).whenComplete(() => isOpen = false);
  }
}

class FooterWidget extends StatefulWidget {
  final bool? isSubscribe;

  const FooterWidget({super.key, this.isSubscribe});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  bool isTablet = true;

  @override
  Widget build(BuildContext context) {
    isTablet = getDeviceType() == "tablet";

    return Column(
      children: [
        if (widget.isSubscribe ?? false)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/footer_bg.png',
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Subsribe for receive our best offer and daily update",
                  fontSize: 18,
                  color: colorWhite,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: getWidth() / 3,
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "example@gmail.com",
                            hintStyle: GoogleFonts.mulish(
                                color: greyTextSubtitle, fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.email_rounded,
                          color: colorWhite,
                        )),
                  ],
                ),
              ],
            ),
          ),
        Container(
          width: double.infinity,
          color: colorGrey.withOpacity(0.2),
          padding: EdgeInsets.all(isTablet ? 32 : 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContentFooter(
                    title: "company".tr,
                    content: [
                      FooterList(
                        content: "about_us".tr,
                      ),
                      FooterList(
                        content: "term_condition".tr,
                      ),
                      FooterList(
                        content: "carrer".tr,
                      ),
                      FooterList(
                        content: "contact_us".tr,
                      ),
                      FooterList(
                        content: "more_link".tr,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: isTablet ? 0 : 20),
                    child: _buildContentFooter(
                      title: "service_tour".tr,
                      content: [
                        FooterList(
                          content: "promo".tr,
                        ),
                        FooterList(
                          content: "tours".tr,
                        ),
                        FooterList(
                          content: "domestic".tr,
                        ),
                        FooterList(
                          content: "2_can_go".tr,
                        ),
                        FooterList(
                          content: "easy_to_go".tr,
                        ),
                      ],
                    ),
                  ),
                  if (isTablet)
                    _buildContentFooter(
                      title: "contact_info".tr,
                      content: [
                        FooterList(
                          icon: Icons.near_me_rounded,
                          content:
                              "Mall Jagung 2 Square UG Blok B No 057-058\nJalan Gunung Sahari Raya No. 1, Jakarta Utara, DKI Jakarta 14420.",
                        ),
                        FooterList(
                          icon: Icons.phone_rounded,
                          content: "+62 21 2262 0285",
                        ),
                        FooterList(
                          icon: Icons.email_rounded,
                          content: "${"information".tr} : davitavel@gmail.com",
                        ),
                        FooterList(
                          icon: Icons.email_rounded,
                          content: "${"tour".tr} : davitavel@gmail.com",
                        ),
                        FooterList(
                          icon: Icons.email_rounded,
                          content: "${"reservation".tr} : davitavel@gmail.com",
                        ),
                        FooterList(
                          icon: Icons.email_rounded,
                          content: "${"ticketing".tr} : davitavel@gmail.com",
                        ),
                      ],
                    ),
                  if (isTablet)
                    _buildContentFooter(
                      title: "article_event".tr,
                      content: [
                        FooterList(
                          content:
                              "5 Hal Penting yang Perlu\nDiketahui Saat Anda Melakukan",
                          img: "assets/images/img_footer_one.png",
                        ),
                        FooterList(
                          content:
                              "10 Tempat Wisata Terkenal Yang\nSelalu menjadi Pilihan Utama",
                          img: "assets/images/img_footer_one.png",
                        ),
                        FooterList(
                          content:
                              "Tour Bangkok Sebagai Pilihan\nLibur Akhir Tahun 2018",
                          img: "assets/images/img_footer_one.png",
                        ),
                        FooterList(
                          content:
                              "Liburan Akhir Tahun Dengan\nPromo Menarik dari Callista Tour",
                          img: "assets/images/img_footer_one.png",
                        ),
                      ],
                    ),
                ],
              ),
              if (!isTablet)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildContentFooter(
                    title: "contact_info".tr,
                    content: [
                      FooterList(
                        icon: Icons.near_me_rounded,
                        content:
                            "Mall Jagung 2 Square UG Blok B No 057-058\nJalan Gunung Sahari Raya No. 1,\nJakarta Utara, DKI Jakarta 14420.",
                      ),
                      FooterList(
                        icon: Icons.phone_rounded,
                        content: "+62 21 2262 0285",
                      ),
                      FooterList(
                        icon: Icons.email_rounded,
                        content: "${"information".tr} : davitavel@gmail.com",
                      ),
                      FooterList(
                        icon: Icons.email_rounded,
                        content: "${"tour".tr} : davitavel@gmail.com",
                      ),
                      FooterList(
                        icon: Icons.email_rounded,
                        content: "${"reservation".tr} : davitavel@gmail.com",
                      ),
                      FooterList(
                        icon: Icons.email_rounded,
                        content: "${"ticketing".tr} : davitavel@gmail.com",
                      ),
                    ],
                  ),
                ),
              if (!isTablet)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildContentFooter(
                    title: "article_event".tr,
                    content: [
                      FooterList(
                        content:
                            "5 Hal Penting yang Perlu\nDiketahui Saat Anda Melakukan",
                        img: "assets/images/img_footer_one.png",
                      ),
                      FooterList(
                        content:
                            "10 Tempat Wisata Terkenal Yang\nSelalu menjadi Pilihan Utama",
                        img: "assets/images/img_footer_one.png",
                      ),
                      FooterList(
                        content:
                            "Tour Bangkok Sebagai Pilihan\nLibur Akhir Tahun 2018",
                        img: "assets/images/img_footer_one.png",
                      ),
                      FooterList(
                        content:
                            "Liburan Akhir Tahun Dengan\nPromo Menarik dari Callista Tour",
                        img: "assets/images/img_footer_one.png",
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentFooter({String? title, List<FooterList>? content}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title ?? "Company",
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < (content?.length ?? 0); i++)
          Column(
            children: [
              if (i != 0) SizedBox(height: content?[i].img != null ? 10 : 5),
              Row(
                children: [
                  content?[i].img != null
                      ? Image.asset(
                          'assets/images/img_footer_one.png',
                          fit: BoxFit.cover,
                          width: 55,
                          height: 30,
                        )
                      : Icon(
                          content?[i].icon ??
                              Icons.keyboard_double_arrow_right_rounded,
                          size: 15,
                        ),
                  SizedBox(width: content?[i].img != null ? 10 : 3),
                  CustomText(
                    text: content?[i].content ?? "About Us",
                    fontSize: 13,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
