import 'dart:developer';
import 'dart:typed_data';

import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:davis_travel/model/city.dart';
import 'package:davis_travel/model/user_data.dart';
import 'package:davis_travel/repository/auth_provider.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:google_translate/google_translate.dart';
import 'package:davis_travel/utils/app_helpers.dart';
import 'package:davis_travel/utils/dialogs.dart';
import 'package:davis_travel/utils/shared_helpers.dart';
import 'package:davis_travel/widget/button_widget.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  bool isLoading = false;
  double opacityTitle = 0;
  List<City> listCity = [];

  String? cityCustom;

  final dataCity = [];

  String lang = "en";
  UserData? userAuth;

  @override
  void initState() {
    super.initState();
    init();
    initUser();
  }

  void initUser() async {
    await AuthProvider.getProfile().then((value) {
      if (value != null) {
        setState(() {
          userAuth = value;
        });
      }
    });
  }

  void init() async {
    setState(() {
      isLoading = true;
    });

    await AuthProvider.getCity().then((value) async {
      if (value.isNotEmpty) {
        setState(() {
          listCity = value;
        });

        log("Get city: ${Get.parameters['name']}");
        if (Get.parameters['name'] != null) {
          cityCustom = Get.parameters['name'];

          log("Get cityCustom: $cityCustom ${listCity.any((e) => e.name?.toLowerCase() == cityCustom)}");

          if (listCity.any((e) => e.name?.toLowerCase() == cityCustom)) {
            listCity
                .firstWhere((e) => e.name?.toLowerCase() == cityCustom)
                .price = await convert(listCity
                    .firstWhere((e) => e.name?.toLowerCase() == cityCustom)
                    .price ??
                0);
            (listCity
                        .firstWhere((e) => e.name?.toLowerCase() == cityCustom)
                        .description ??
                    "")
                .translate(sourceLanguage: 'en', targetLanguage: 'ja')
                .then((value) {
              log(value);
              setState(() {
                listCity
                    .firstWhere((e) => e.name?.toLowerCase() == cityCustom)
                    .description = value;
              });
            });
          }
        } else {
          for (var i = 0; i < listCity.length; i++) {
            log("Before $i: ${listCity[i].price}");
            Future.delayed(const Duration(milliseconds: 100))
                .then((value) async {
              listCity[i].price = await convert(listCity[i].price ?? 0);
              log("After $i: ${listCity[i].price}");

              setState(() {});
            });
          }
        }

        setState(() {});
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  Future<int> convert(int price) async {
    lang = await getSharedString("localeId") ?? "en";

    if (lang != "ja") {
      return (await CurrencyConverter.convert(
                from: Currency.jpy,
                to: lang == "id" ? Currency.idr : Currency.usd,
                amount: price.toDouble(),
              ) ??
              0)
          .round();
    } else {
      return price;
    }
  }

  bool isTablet = true;

  @override
  Widget build(BuildContext context) {
    isTablet = getDeviceType() == "tablet";

    listCity.sort((a, b) =>
        a.name?.toLowerCase().compareTo(b.name?.toLowerCase() ?? "") ?? 0);

    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        if (cityCustom == null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: isTablet ? (getWidth() * 0.2) : 20, vertical: 150),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  colorBlack.withOpacity(0.5),
                  BlendMode.darken,
                ),
                image: const AssetImage(
                  'assets/images/bg_city.png',
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "visit_these_romantic".tr,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colorWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text: "visit_these_romantic_desc".tr,
                  fontSize: 18,
                  color: colorWhite,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        if (cityCustom == null)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: isTablet ? (getWidth() * 0.2) : 20,
                vertical: isTablet ? 150 : 100),
            color: colorWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "complete_your_experience".tr,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colorTextPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomText(
                  text: "complete_your_experience_desc".tr,
                  fontSize: 18,
                  color: colorTextPrimary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        cityCustom == null
            ? ListView.builder(
                itemCount: listCity.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return cardWidget(listCity[index]);
                })
            : (listCity.any((e) => e.name?.toLowerCase() == cityCustom)
                ? cardWidget(listCity
                    .firstWhere((e) => e.name?.toLowerCase() == cityCustom))
                : emptyPage()),
      ],
    );
  }

  Widget emptyPage() {
    return Container(
      width: double.infinity,
      height: getHeight(),
      padding: EdgeInsets.symmetric(
          horizontal: isTablet ? (getWidth() / 3) : 20,
          vertical: isTablet ? 150 : 100),
      color: greyTextSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: "city_not_avaiable".tr,
            style: GoogleFonts.robotoSlab(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colorTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          CustomText(
            text: "city_not_avaiable_desc".tr,
            fontSize: 18,
            color: colorTextPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ButtonWidget(
              label: "back_to_home",
              onPressed: () {
                Get.toNamed("/home");
              }),
        ],
      ),
    );
  }

  Widget cardWidget(City city, {double? width}) {
    String stirngPrice =
        "${lang == "id" ? "Rp " : ""}${NumberFormat("#,##0", "en_US").format(city.price)}${lang == "ja" ? " Yen" : (lang == "en" ? " USD" : "")}";

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: isTablet ? (getWidth() * 0.2) : 20,
                vertical: isTablet ? 150 : 100),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(city.image ?? ""),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  colorBlack.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: city.name ?? "",
                  style: GoogleFonts.robotoSlab(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colorWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text: city.description ?? "",
                  fontSize: 18,
                  color: colorWhite,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              vertical: 40,
              horizontal: isTablet ? (getWidth() * 0.2) : 20,
            ),
            padding: EdgeInsets.all(isTablet ? 30 : 20),
            decoration: BoxDecoration(
              color: const Color(0xFF15396B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "${"starting_from".tr} $stirngPrice",
                  color: colorWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                const SizedBox(height: 20),
                CustomText(
                  text: "additional_charges".tr,
                  color: colorWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < (city.benefit?.length ?? 0); i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: colorWhite),
                        ),
                        const SizedBox(width: 10),
                        CustomText(
                          text: city.benefit?[i] ?? "",
                          fontSize: 16,
                          color: colorWhite,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                ButtonWidget(
                    label: "get_started".tr,
                    backgroundColor: colorWhite,
                    borderColor: colorWhite,
                    textColor: const Color(0xFF15396B),
                    onPressed: () async {
                      if (userAuth != null) {
                        actionStarted();
                      } else {
                        showAlertDialog(
                            title: "information".tr,
                            content: "please_login".tr);
                      }
                      /*
                      for (var i = 0; i < dataCity.length; i++) {
                        await AuthProvider.addCity(
                                city: City.fromJson(dataCity[i]))
                            .then((value) => init());
                      }
                      */
                    })
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 40,
              horizontal: isTablet ? (getWidth() * 0.2) : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: city.name ?? "",
                      fontSize: 29,
                    ),
                  ],
                ),
                const SizedBox(height: 27),
                if (city.label != null && (city.label?.isNotEmpty ?? false))
                  CustomText(
                    text: city.label ?? "",
                    fontSize: 18,
                    color: greyTextSubtitle,
                    padding: const EdgeInsets.only(bottom: 27),
                  ),
                for (var i = 0; i < (city.details?.length ?? 0); i++)
                  CustomText(
                    text:
                        "${city.details?[i].name ?? ""}: ${city.details?[i].detail ?? ""}",
                    fontSize: 18,
                    color: greyTextSubtitle,
                    textAlign: TextAlign.justify,
                    padding: const EdgeInsets.only(bottom: 17),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> actionStarted() async {
    isTablet = getDeviceType() == "tablet";

    bool loadStart = false;

    String? gender = "male";

    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController cardController = TextEditingController();
    final TextEditingController citizenController = TextEditingController();
    final TextEditingController passportController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController countryController = TextEditingController();

    if (userAuth != null) {
      firstNameController.text =
          (userAuth?.displayName?.split(" ").isNotEmpty ?? false)
              ? (userAuth?.displayName?.split(" ").first ?? "")
              : "";
      lastNameController.text =
          ((userAuth?.displayName?.split(" ").length ?? 0) > 1)
              ? (userAuth?.displayName?.split(" ")[1] ?? "")
              : "";
    }

    await showCupertinoDialog(
        context: Get.context!,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              content: SizedBox(
                width: isTablet ? (getWidth() / 2) : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: 'your_data'.tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colorTextPrimary,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                                hintText: "first_name".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                                hintText: "last_name".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                hintText: "email".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: mobileController,
                            decoration: InputDecoration(
                                hintText: "mobile_number".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomText(text: "gender".tr),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    gender = "female";
                                  });
                                },
                                child: Row(
                                  children: [
                                    CupertinoRadio<String>(
                                        value: "male",
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value;
                                          });
                                        }),
                                    const SizedBox(width: 5),
                                    CustomText(text: "male".tr),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    gender = "female";
                                  });
                                },
                                child: Row(
                                  children: [
                                    CupertinoRadio<String>(
                                        value: "female",
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value;
                                          });
                                        }),
                                    const SizedBox(width: 5),
                                    CustomText(text: "female".tr),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: cardController,
                            decoration: InputDecoration(
                                hintText: "id_card_number".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: citizenController,
                            decoration: InputDecoration(
                                hintText: "citizenship".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: passportController,
                            decoration: InputDecoration(
                                hintText: "passport_number".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: streetController,
                      decoration: InputDecoration(
                          hintText: "street_address".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: countryController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "issuing_country".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                        label: 'next'.tr,
                        radius: 20,
                        isLoading: loadStart,
                        onPressed: () async {
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
                          } else if (emailController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_email".tr,
                            );
                          } else if (mobileController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_mobile".tr,
                            );
                          } else if (cardController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_card".tr,
                            );
                          } else if (citizenController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_citizen".tr,
                            );
                          } else if (passportController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_passport".tr,
                            );
                          } else if (streetController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_street".tr,
                            );
                          } else if (countryController.text.isEmpty) {
                            showAlertDialog(
                              title: 'information'.tr,
                              content: "please_fill_country".tr,
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        }),
                  ],
                ),
              ),
            );
          });
        });
  }
}
