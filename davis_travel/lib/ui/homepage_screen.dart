import 'dart:math';

import 'package:davis_travel/model/city.dart';
import 'package:davis_travel/repository/auth_provider.dart';
import 'package:davis_travel/ui/web_widget.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/utils/app_helpers.dart';
import 'package:davis_travel/widget/button_widget.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  bool isLoading = false;
  List<City> lisCity = [];
  List<PrivateTrip> listTrip = [];

  bool isTablet = true;

  double widthNeed = 105;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });

    await AuthProvider.getCity().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          lisCity = List.from(value)..shuffle(Random());
        });
      }

      setState(() {
        isLoading = false;
      });
    });

    setState(() {
      isLoading = true;
    });

    await AuthProvider.getTrip().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          listTrip = value;
        });
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    isTablet = getDeviceType() == "tablet";

    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: double.infinity,
          height: getHeight(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/skyfast_bg.jpg',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(opacity: 0, child: socialMediaCard()),
              Row(
                children: [
                  Container(
                    width: isTablet ? (getWidth() / 2.5) : (getWidth() - 40),
                    padding: const EdgeInsets.all(20),
                    margin: EdgeInsets.only(left: isTablet ? 64 : 20),
                    decoration: BoxDecoration(
                        color: colorBlack.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "come_to_japan".tr,
                          style: GoogleFonts.robotoSlab(
                            fontSize: isTablet ? 48 : 26,
                            fontWeight: FontWeight.bold,
                            color: colorWhite,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          text: "come_to_japan_desc".tr,
                          fontSize: 18,
                          color: colorWhite,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  socialMediaCard(),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: colorWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "popular_destinations".tr,
                fontSize: 24,
                textAlign: TextAlign.center,
                padding: EdgeInsets.all(isTablet ? 64 : 20),
              ),
              SizedBox(
                height: 210,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: lisCity.length > 6 ? 6 : lisCity.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 15);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 20 : 0),
                        child: BuildPopular(
                            title: lisCity[index].name,
                            accommodation:
                                "${lisCity[index].price ?? 0} ${"accommodations".tr}",
                            image: lisCity[index].image),
                      );
                    }),
              )
            ],
          ),
        ),
        Container(
          color: colorWhite,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 32 : 20),
            margin: EdgeInsets.all(isTablet ? 64 : 20),
            decoration: BoxDecoration(
                color: const Color(0xFF003768),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                if (isTablet)
                  InkWell(
                    onTap: () {},
                    onHover: (value) {
                      if (value) {
                        setState(() {
                          widthNeed = 200;
                        });
                      } else {
                        setState(() {
                          widthNeed = 105;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeIn,
                      width: widthNeed,
                      height: 172,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorWhite, width: 4),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/photo_need.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isTablet) const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "what_do_you_need".tr,
                        color: colorWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              text: "what_do_you_need_desc".tr,
                              color: colorWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isTablet)
                            Container(
                                margin: const EdgeInsets.only(left: 25),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(12)),
                                child: CustomText(
                                  text: "Click Here".tr,
                                  color: const Color(0xFF003768),
                                ))
                        ],
                      ),
                      if (!isTablet)
                        Container(
                            margin: const EdgeInsets.only(top: 25),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(12)),
                            child: CustomText(
                              text: "Click Here".tr,
                              color: const Color(0xFF003768),
                            ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          color: colorWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "private_trip".tr,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              CustomText(
                text: "coming_soon".tr,
                fontSize: 18,
                color: colorRed2,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed("/city");
                    },
                    child: CustomText(
                      text: "learn_more".tr,
                      color: colorBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomText(
                    text: "booking_now".tr,
                    color: colorBlue,
                  ),
                ],
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
        isTablet
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 350,
                    color: colorWhite,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: listTrip.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 30 : 0, right: 30),
                            child: _buildTrip(listTrip[index]),
                          );
                        }),
                  ),
                ],
              )
            : Container(
                color: colorWhite,
                height: 350,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listTrip.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 30 : 0, right: 30),
                        child: _buildTrip(listTrip[index]),
                      );
                    }),
              ),
        Container(
          width: double.infinity,
          color: colorWhite,
          padding: EdgeInsets.all(isTablet ? 64 : 30),
          child: Row(
            children: [
              if (isTablet)
                Expanded(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage(
                          'assets/images/phone_price.png',
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "honeymoon_trips".tr,
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: "regular_trips_desc".tr,
                      fontSize: 20,
                    ),
                    const SizedBox(height: 20),
                    needBooking(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: colorWhite,
          padding: EdgeInsets.all(isTablet ? 64 : 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "more_special_offers".tr,
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: "regular_trips_desc".tr,
                      fontSize: 20,
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Icon(Icons.video_call),
                        SizedBox(width: 10),
                        CustomText(
                          text: "Videographer",
                          fontSize: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(Icons.video_call),
                        SizedBox(width: 10),
                        CustomText(
                          text: "Photograph",
                          fontSize: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(Icons.video_call),
                        SizedBox(width: 10),
                        CustomText(
                          text: "Babysitter",
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isTablet)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 310,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage(
                              'assets/images/people_thumb.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: ButtonWidget(
                            label: "special_offer".tr,
                            backgroundColor: colorWhite,
                            textColor: colorPrimary,
                            radius: 20,
                            onPressed: () {}),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: colorBlack,
          padding: EdgeInsets.all(isTablet ? 64 : 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "travel_history".tr,
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                      color: colorWhite,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: "regular_trips_desc".tr,
                      fontSize: 20,
                      color: colorWhite,
                    ),
                  ],
                ),
              ),
              if (isTablet) const SizedBox(width: 100),
              if (isTablet)
                Expanded(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/travel_history.png',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const FooterWidget(),
      ],
    );
  }

  Widget socialMediaCard() {
    return Container(
      width: isTablet ? (getWidth() / 4) : (getWidth() - 40),
      margin: EdgeInsets.all(isTablet ? 64 : 20),
      decoration: BoxDecoration(
          color: colorWhite, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/tiktok.png',
              ),
            )),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/whatsapp.png',
              ),
            )),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/instagram.png',
              ),
            )),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/youtube.png',
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget needBooking() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CircleAvatar(),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "need_booking".tr,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorTextPrimary,
            ),
            const SizedBox(height: 5),
            CustomText(
              text: "ask_a_specialist".tr,
              fontSize: 14,
              color: colorPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrip(PrivateTrip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 250,
          height: 250,
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(trip.image ?? ""),
            ),
          ),
          child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: colorWhite, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomText(
                    text: "4.5",
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.star_rounded,
                    color: colorYellow,
                  )
                ],
              )),
        ),
        const SizedBox(height: 20),
        CustomText(
          text: trip.type ?? "Private",
          fontSize: 18,
        ),
        const SizedBox(height: 7),
        CustomText(
          text: trip.name ?? "Sakura Trip",
          fontSize: 28,
        ),
      ],
    );
  }
}

class BuildPopular extends StatefulWidget {
  final String? title;
  final String? accommodation;
  final String? image;

  const BuildPopular({super.key, this.title, this.accommodation, this.image});

  @override
  State<BuildPopular> createState() => _BuildPopularState();
}

class _BuildPopularState extends State<BuildPopular> {
  double widthPopular = 100;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widthPopular == 100 ? colorWhite : colorBgScreen,
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed("/city/${widget.title?.toLowerCase()}");
        },
        onHover: (value) {
          if (value) {
            setState(() {
              widthPopular = 120;
            });
          } else {
            setState(() {
              widthPopular = 100;
            });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              width: widthPopular,
              height: widthPopular,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(widthPopular == 100 ? 50 : 20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.image ?? "", scale: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomText(
              text: widget.title ?? "Prefektur Mie",
              fontSize: 20,
            ),
            Opacity(
              opacity: 0,
              child: CustomText(
                text: "52500 accomodations",
                fontSize: 12,
                color: colorWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
