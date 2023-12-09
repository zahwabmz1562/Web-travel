import 'package:davis_travel/ui/booking_screen.dart';
import 'package:davis_travel/ui/city_screen.dart';
import 'package:davis_travel/ui/dashboard_screen.dart';
import 'package:davis_travel/ui/homepage_screen.dart';
import 'package:davis_travel/ui/privacy_screen.dart';
import 'package:davis_travel/ui/profile_screen.dart';
import 'package:davis_travel/ui/transport_screen.dart';
import 'package:davis_travel/ui/upload_screen.dart';
import 'package:davis_travel/ui/web_widget.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HeaderWidget(mainWidget: HomepageScreen()),
    ),
    GetPage(
      name: AppRoutes.booking,
      page: () => const BookingScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.upload,
      page: () => const HeaderWidget(mainWidget: UploadScreen(), isStay: true),
    ),
    GetPage(
      name: AppRoutes.transport,
      page: () => const HeaderWidget(mainWidget: TransportScreen()),
    ),
    GetPage(
      name: AppRoutes.city,
      page: () => const HeaderWidget(mainWidget: CityScreen()),
    ),
    GetPage(
      name: AppRoutes.cityName,
      page: () => const HeaderWidget(mainWidget: CityScreen()),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const HeaderWidget(mainWidget: ProfileScreen(), isStay: true),
    ),
    GetPage(
      name: AppRoutes.privacy,
      page: () => const HeaderWidget(mainWidget: PrivacyScreen(), isStay: true),
    ),
  ];
}
