import 'package:davis_travel/router/app_pages.dart';
import 'package:davis_travel/translations/app_translations.dart';
import 'package:davis_travel/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_translate/google_translate.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleTranslate.initialize(
    apiKey: 'AIzaSyAMvco3kN8Mp9D2LGL5rkeAtIWfeSZwbeU',
    sourceLanguage: "en",
    targetLanguage: "ja",
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skyfast Tour & Travel',
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      translations: AppTranslations(),
      theme: ThemeData(
        primaryColor: colorPrimary,
        textTheme: GoogleFonts.mulishTextTheme(),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: colorSecondary),
      ),
      getPages: AppPages.routes,
      initialRoute: AppPages.initial,
    );
  }
}
