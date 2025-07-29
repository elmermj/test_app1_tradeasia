import 'package:flutter/material.dart';
import 'package:test_app1/utils/interfaces/x_get_view.dart';
import './splash_controller.dart';

class SplashPage extends XGetView<SplashController> {
    
  const SplashPage({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: k.blackToMidnightBlue,
        ),
        child: Center(
          child: Text(
            'TradeAsia',
            style: k.darkOnWhiteTextXL,
          )
        ),
      ),
    );
  }
}