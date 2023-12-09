import 'package:davis_travel/ui/web_widget.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:davis_travel/widget/button_widget.dart';
import 'package:davis_travel/widget/custom_text.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/booking_bg.png',
              ),
            ),
          ),
          child: CustomText(
            text: "Upload Travel History",
            fontSize: 32,
            color: colorWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: double.infinity,
          color: colorWhite,
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Upload Travel History",
                      fontSize: 20,
                    ),
                    const SizedBox(height: 20),
                    _textField(title: "Place Name"),
                    const SizedBox(height: 15),
                    _textField(title: "Location"),
                    const SizedBox(height: 15),
                    _textField(title: "Travel Route"),
                    const SizedBox(height: 15),
                    _textField(title: "Description"),
                    const SizedBox(height: 15),
                    TextFormField(
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    const SizedBox(height: 15),
                    ButtonWidget(label: "Send", onPressed: () {})
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/skyfast_bg.png',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      label: "Upload Image",
                      radius: 10,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 20),
                    const CustomText(
                      text: "Contact Info",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.place_rounded,
                          size: 15,
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: CustomText(
                            text:
                                "Mall Jagung 2 Square UG Blok B No 057-058 Jalan Gunung Sahari Raya No. 1, Jakarta Utara, DKI Jakarta 14420.",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone_iphone_rounded,
                          size: 15,
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: CustomText(
                            text: "+62 657567890",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_rounded,
                          size: 15,
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: CustomText(
                            text:
                                "Informasi : davitavel@gmail.com\nTour : davitavel@gmail.com\nReservasi : davitavel@gmail.com\nTicketing : davitavel@gmail.com",
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const FooterWidget(isSubscribe: true),
      ],
    );
  }

  Widget _textField({required String title}) {
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 150),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: greyBorder.withOpacity(0.7),
            border: const Border(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: CustomText(
            text: title,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            )),
          ),
        ),
      ],
    );
  }
}
