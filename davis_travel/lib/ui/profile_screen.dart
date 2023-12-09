import 'package:davis_travel/ui/web_widget.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/utils/app_helpers.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool isTablet = true;

  @override
  Widget build(BuildContext context) {
    isTablet = getDeviceType() == "tablet";

    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                color: colorBlue,
                child: Column(
                  children: [
                    CustomText(
                      text: "welcome_to_skyfast_tour".tr,
                      fontSize: 32,
                      color: colorWhite,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "professional_tour_guide".tr,
                                fontSize: 20,
                                color: colorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 25),
                              CustomText(
                                text: "about_us".tr,
                                fontSize: 20,
                                color: colorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 12),
                              CustomText(
                                text: "about_us_desc".tr,
                                fontSize: 20,
                                color: colorWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        if (isTablet)
                          Container(
                            width: 300,
                            height: 300,
                            margin: const EdgeInsets.only(left: 100),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/profile_1.png',
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    if (isTablet)
                      Container(
                        width: 300,
                        height: 300,
                        margin: const EdgeInsets.only(right: 100),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/profile_2.png',
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: "why_choose_us".tr,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 20),
                          CustomText(
                            text: "why_choose_us_desc_one".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "why_choose_us_desc_two".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "why_choose_us_desc_three".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "why_choose_us_desc_four".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "why_choose_us_desc_five".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                color: colorBlue,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "companys_tax".tr,
                            fontSize: 20,
                            color: colorWhite,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text:
                                "${"companys_npwp".tr} : 50.053.015.9-203.000\n${"registered_name".tr} : PT. Skyfast Tour\n${"registered_address".tr} : Jl. Khatib Sulaiman RT. 0 RW. 0 Kolok Mudiak, Barangin Kota Sawahlunto Sumatera Barat",
                            color: colorWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    if (isTablet)
                      Container(
                        width: 300,
                        height: 300,
                        margin: const EdgeInsets.only(left: 100),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/profile_3.png',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const FooterWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
