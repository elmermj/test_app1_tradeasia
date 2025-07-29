import 'package:get/get.dart';
import 'package:test_app1/utils/routes.dart';
import 'package:test_app1/utils/log.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    Log.cyan('SplashController initialized');
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    Log.cyan('SplashController ready, starting navigation timer');

    await Future.delayed(const Duration(seconds: 2), () {
      Log.cyan('Navigating to home page');
      Get.offAllNamed(Routes.homePage);
    });
  }
}