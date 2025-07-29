import 'package:get/get.dart';
import 'package:test_app1/utils/log.dart';

abstract class XGetxController extends GetxController  {
  String base = '';

  @override
  void onInit() {
    super.onInit();
    base = runtimeType.toString().replaceAll('Controller', 'Page');
    initialize();
  }

  void initialize();


  void logRed(String message) {
    Log.red("$runtimeType::$message");
  }

  void logGreen(String message) {
    Log.green("$runtimeType::$message");
  }

  void logYellow(String message) {
    Log.yellow("$runtimeType::$message");
  }

  void logCyan(String message) {
    Log.cyan("$runtimeType::$message");
  }

  void logPink(String message) {
    Log.pink("$runtimeType::$message");
  }

}
