import 'package:davis_travel/model/transportation.dart';
import 'package:davis_travel/repository/auth_provider.dart';
import 'package:davis_travel/ui/web_widget.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/utils/app_helpers.dart';
import 'package:davis_travel/widget/button_widget.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  bool isLoading = false;
  double opacityTitle = 0;
  List<Transportation> listTransport = [];
  List<Transportation> listHotel = [];

  @override
  void initState() {
    super.initState();
    initTransport();
    initHotel();
  }

  final data = [];

  void initTransport() async {
    setState(() {
      isLoading = true;
    });

    await AuthProvider.getTransaport().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          listTransport = value;
        });
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void initHotel() async {
    setState(() {
      isLoading = true;
    });

    await AuthProvider.getHotel().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          listHotel = value;
        });
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  bool isTablet = true;

  @override
  Widget build(BuildContext context) {
    isTablet = getDeviceType() == "tablet";

    final carType = listTransport.where((e) => e.type == "car").toList();
    final trainType = listTransport.where((e) => e.type == "train").toList();

    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
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
                'assets/images/bg_transport.png',
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "explore_your_best".tr,
                style: GoogleFonts.robotoSlab(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: colorWhite,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CustomText(
                text: "explore_your_best_desc".tr,
                fontSize: 18,
                color: colorWhite,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        isTablet ? listCard(carType) : listCardMobile(carType),
        listTrain(trainType),
        isTablet ? listHotels(listHotel) : listHotelsMobile(listHotel),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: isTablet ? (getWidth() / 3) : 20,
              vertical: isTablet ? 150 : 100),
          color: colorWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "join_us".tr,
                style: GoogleFonts.robotoSlab(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: colorTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomText(
                text: "join_us_desc".tr,
                fontSize: 18,
                color: colorTextPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ButtonWidget(
                  label: "WhatsApp",
                  onPressed: () {
                    String phone = "6285325949449";
                    String message =
                        "I'm interested in joining as a tour guide partner with Skyfast Tour. Could you please provide more information about the opportunity?";

                    String url =
                        "https://wa.me/$phone?text=${message.replaceAll(" ", "%20")}";

                    launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  })
            ],
          ),
        ),
        const FooterWidget(),
      ],
    );
  }

  Widget listCard(List<Transportation> list) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: (list.length / 2).ceil(),
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: getWidth() / 5, vertical: 100),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 50);
      },
      itemBuilder: (context, index) {
        final firstIndex = index * 2;
        final secondIndex = firstIndex + 1;

        return index % 2 == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (firstIndex < list.length)
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: cardWidget(
                        list[firstIndex].name ?? "None",
                        list[firstIndex].description ?? "None",
                        list[firstIndex].image ?? "",
                        width: 200,
                      ),
                    ),
                  if (secondIndex < list.length)
                    Expanded(
                      child: cardWidget(
                        list[secondIndex].name ?? "None",
                        list[secondIndex].description ?? "None",
                        list[secondIndex].image ?? "",
                      ),
                    ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (firstIndex < list.length)
                    Expanded(
                      child: cardWidget(
                        list[firstIndex].name ?? "None",
                        list[firstIndex].description ?? "None",
                        list[firstIndex].image ?? "",
                      ),
                    ),
                  if (secondIndex < list.length)
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: cardWidget(
                        list[secondIndex].name ?? "None",
                        list[secondIndex].description ?? "None",
                        list[secondIndex].image ?? "",
                        width: 200,
                      ),
                    ),
                ],
              );
      },
    );
  }

  Widget listCardMobile(List<Transportation> list) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 32);
      },
      itemBuilder: (context, index) {
        return cardWidget(
          list[index].name ?? "None",
          list[index].description ?? "None",
          list[index].image ?? "",
          width: double.infinity,
        );
      },
    );
  }

  Widget listTrain(List<Transportation> list) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      padding: EdgeInsets.symmetric(
          horizontal: isTablet ? (getWidth() / 5.2) : 16,
          vertical: isTablet ? 100 : 32),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        childAspectRatio: isTablet ? 0.82 : 0.42,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: cardWidget(
            list[index].name ?? "None",
            list[index].description ?? "None",
            list[index].image ?? "",
          ),
        );
      },
    );
  }

  Widget listHotels(List<Transportation> list) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: getWidth() / 4, vertical: 100),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 50);
      },
      itemBuilder: (context, index) {
        return index % 2 == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(list[index].image ?? ""),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: list[index].name ?? "",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 20),
                        CustomText(
                          text: list[index].description ?? "",
                          fontSize: 16,
                          color: greyTextSubtitle,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ButtonWidget(
                              label: "get_started".tr,
                              backgroundColor: colorBlack,
                              borderColor: colorBlack,
                              onPressed: () async {
                                /*
                                for (var i = 0; i < data.length; i++) {
                                  await AuthProvider.addHotel(
                                    name: data[i]['name'],
                                    description: data[i]['description'],
                                  ).then((value) {
                                    initHotel();
                                  });
                                }
                                */
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: list[index].name ?? "",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 20),
                        CustomText(
                          text: list[index].description ?? "",
                          fontSize: 16,
                          color: greyTextSubtitle,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ButtonWidget(
                              label: "get_started".tr,
                              backgroundColor: colorBlack,
                              borderColor: colorBlack,
                              onPressed: () {}),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(list[index].image ?? ""),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget listHotelsMobile(List<Transportation> list) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 32);
      },
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(list[index].image ?? ""),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: list[index].name ?? "",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 20),
                CustomText(
                  text: list[index].description ?? "",
                  fontSize: 16,
                  color: greyTextSubtitle,
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                    label: "get_started".tr,
                    backgroundColor: colorBlack,
                    borderColor: colorBlack,
                    onPressed: () async {}),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget cardWidget(String title, String description, String image,
      {double? width}) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CustomText(text: title),
          const SizedBox(height: 7),
          CustomText(
            text: description,
            fontSize: 14,
            color: greyTextSubtitle,
          ),
        ],
      ),
    );
  }
}
