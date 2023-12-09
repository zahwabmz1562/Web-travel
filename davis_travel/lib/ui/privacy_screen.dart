import 'package:davis_travel/ui/web_widget.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/utils/app_helpers.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "privacy_data_policy".tr,
                            fontSize: isTablet ? 32 : 24,
                            color: colorWhite,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: isTablet ? 50 : 24),
                          CustomText(
                            text: "privacy_data_policy_desc".tr,
                            fontSize: isTablet ? 20 : 18,
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
                              'assets/images/privacy_1.png',
                            ),
                          ),
                        ),
                      )
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
                              'assets/images/privacy_2.png',
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isTablet
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "information_collect".tr,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 20),
                          CustomText(
                            text:
                                "a. ${"information_collect_decs_one".tr}\n\nb. ${"information_collect_decs_two".tr}",
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
                            text: "your_information".tr,
                            fontSize: 20,
                            color: colorWhite,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text:
                                "a. ${"your_information_desc_one".tr}\n\nb. ${"your_information_desc_two".tr}",
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
                              'assets/images/privacy_3.png',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                color: colorWhite,
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
                              'assets/images/privacy_4.png',
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isTablet
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "links_third".tr,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "links_third_desc".tr,
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
                color: colorWhite,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "privacy_policy_changes".tr,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "privacy_policy_changes_desc".tr,
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
                              'assets/images/privacy_5.png',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 32 : 20,
                    horizontal: isTablet ? (getWidth() / 4) : 20),
                color: colorBlue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "contact_us".tr,
                      fontSize: 20,
                      color: colorWhite,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: "contact_us_desc".tr,
                      fontSize: 16,
                      color: colorWhite,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                          color: colorRed,
                          borderRadius: BorderRadius.circular(20)),
                      child: CustomText(
                        text: "agree_send".tr,
                        color: colorWhite,
                        fontWeight: FontWeight.w600,
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
