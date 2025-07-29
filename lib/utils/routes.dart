import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:test_app1/presentation/home/home_bindings.dart';
import 'package:test_app1/presentation/home/home_page.dart';
import 'package:test_app1/presentation/product_details/product_details_bindings.dart';
import 'package:test_app1/presentation/product_details/product_details_page.dart';
import 'package:test_app1/presentation/splash/splash_bindings.dart';
import 'package:test_app1/presentation/splash/splash_page.dart';

class Routes {
  static const String splashPage = '/SplashPage';
  static const String homePage = '/HomePage';
  static const String productDetailsPage = '/ProductDetailsPage';

  static final List<GetPage> pages = [
    GetPage(
      name: splashPage, 
      page: () => const SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: homePage, 
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: productDetailsPage,
      page: () => const ProductDetailsPage(),
      binding: ProductDetailsBindings(),
    ),
  ];
}