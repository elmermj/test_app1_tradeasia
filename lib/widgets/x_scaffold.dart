import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app1/utils/mixins/x_stylings.dart';

class XScaffold extends StatelessWidget with XStylings {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final Gradient? gradient;
  final bool useSafeArea;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;

  XScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.resizeToAvoidBottomInset = true,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.horizontalPadding = 20,
    this.gradient,
    this.useSafeArea = true,
    this.verticalPadding,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {

    Widget paddedBody = Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient ?? k.blackToMidnightBlue,
      ),
      padding: EdgeInsets.only(
        left: leftPadding ?? horizontalPadding ?? 20,
        right: rightPadding ?? horizontalPadding ?? 20,
        top: topPadding ?? verticalPadding ?? 0,
        bottom: bottomNavigationBar != null ? 0 : (bottomPadding ?? verticalPadding ?? 0),
      ),
      child: body,
    );

    if (useSafeArea) {
      paddedBody = SafeArea(child: paddedBody);
    }
    if(bottomNavigationBar != null) {
      paddedBody = Stack(
        children: [
          paddedBody,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: bottomNavigationBar!,
          ),
        ],
      );
    }

    return Scaffold(
      key: key,
      appBar: appBar,
      body: paddedBody,
      floatingActionButton: floatingActionButton != null ? Padding(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + Get.mediaQuery.padding.bottom + (bottomPadding ?? verticalPadding ?? 0)),
        child: floatingActionButton,
      ) : null,
      floatingActionButtonLocation: floatingActionButtonLocation,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor ?? k.customBlack,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
    );
  }
}
