import 'dart:developer';

import 'package:davis_travel/ui/web_widget.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/utils/app_helpers.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double opacityTitle = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(getWidth().toString());

    return Scaffold(
      backgroundColor: colorWhite,
      body: Column(
        children: [
          Expanded(
            child: NotificationListener(
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
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(64),
                    color: colorWhite,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "Book your best trip\nthat you like",
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(height: 10),
                                  CustomText(
                                    text:
                                        "The latest. Take a look at what’s new, right now.",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: greyTextSubtitle,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: _needHelp()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _cardTrip(
                    theme: "Sakura",
                    colorTheme: colorBlack,
                    listContent: [
                      "Day 1 Istirahat di Tokyo/Osaka (sesuai tempat landing)",
                      "Day 2-3-4 start perjalanan trip",
                      "Day 5 istirahat dan belanja oleh-oleh",
                      "Day 6-7-8 start perjalanan trip",
                      "Day 9-10 istirahat / belanja oleh sebelum keberangkatan pulang ke Indonesia (negara masing-masing)",
                    ],
                  ),
                  _cardTrip(
                    theme: "Winter",
                    colorTheme: colorWhite,
                    listContent: [
                      "Day 1 Istirahat di Tokyo/Osaka (sesuai tempat landing)",
                      "Day 2-3-4 start perjalanan trip",
                      "Day 5 istirahat dan belanja oleh-oleh",
                      "Day 6-7-8 start perjalanan trip",
                      "Day 9-10 istirahat / belanja oleh sebelum keberangkatan pulang ke Indonesia (negara masing-masing)",
                    ],
                  ),
                  _cardTrip(
                    theme: "Autumn",
                    colorTheme: colorBlack,
                    listContent: [
                      "Day 1 Istirahat di Tokyo/Osaka (sesuai tempat landing)",
                      "Day 2-3-4 start perjalanan trip",
                      "Day 5 istirahat dan belanja oleh-oleh",
                      "Day 6-7-8 start perjalanan trip",
                      "Day 9-10 istirahat / belanja oleh sebelum keberangkatan pulang ke Indonesia (negara masing-masing)",
                    ],
                  ),
                  _cardTrip(
                    theme: "Summer",
                    colorTheme: colorWhite,
                    listContent: [
                      "Day 1 Istirahat di Tokyo/Osaka (sesuai tempat landing)",
                      "Day 2-3-4 start perjalanan trip",
                      "Day 5 istirahat dan belanja oleh-oleh",
                      "Day 6-7-8 start perjalanan trip",
                      "Day 9-10 istirahat / belanja oleh sebelum keberangkatan pulang ke Indonesia (negara masing-masing)",
                    ],
                  ),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _needHelp({Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Need booking help?",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color ?? colorTextPrimary,
            ),
            const SizedBox(height: 5),
            CustomText(
              text: "Ask a Specialist",
              fontSize: 14,
              color: colorPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardTrip(
      {required String theme,
      required Color colorTheme,
      required List<String> listContent}) {
    Color fontColor = colorTheme == colorBlack ? colorWhite : colorBlack;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(64),
      color: colorTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Book $theme Trip",
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
          const SizedBox(height: 10),
          const CustomText(
            text: "The latest. Take a look at what’s new, right now.",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: greyTextSubtitle,
          ),
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/tokyo_${theme.toLowerCase()}.png',
            height: 270,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(height: 40),
          for (var i = 0; i < listContent.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 9,
                  color: fontColor,
                ),
                const SizedBox(width: 7),
                CustomText(
                  text: listContent[i],
                  color: fontColor,
                  fontSize: 18,
                ),
              ],
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: const BoxDecoration(
                      color: colorBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "From date",
                                fontSize: 20,
                                color: colorWhite,
                              ),
                              const SizedBox(height: 10),
                              CustomText(
                                text: "05/06/2023",
                                fontSize: 14,
                                color: colorWhite,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "To date",
                            fontSize: 20,
                            color: colorWhite,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "05/06/2023",
                            fontSize: 14,
                            color: colorWhite,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Person",
                            fontSize: 20,
                            color: colorWhite,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "05/06/2023",
                            fontSize: 14,
                            color: colorWhite,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Price",
                            fontSize: 20,
                            color: colorWhite,
                          ),
                          const SizedBox(height: 7),
                          CustomText(
                            text: "05/06/2023",
                            fontSize: 14,
                            color: colorWhite,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/booking');
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: colorYellow,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  child: CustomText(
                    text: "Book Now",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorWhite,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              _needHelp(color: fontColor),
            ],
          ),
        ],
      ),
    );
  }
}
