import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app1/utils/mixins/x_stylings.dart';


abstract class XGetView<T extends GetxController> extends GetView<T> with XStylings {

  const XGetView({super.key});


  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }

  Widget buildView(BuildContext context);
}