import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styling {

  Color vantaBlack = const Color(0xFF000000);
  Color customBlack = const Color(0xFF121212);
  Color customWhite = const Color(0xFFFFFFFF);
  Color customGrey = const Color(0xFF808080);
  Color customDarkGrey = const Color.fromARGB(255, 48, 48, 48);
  Color customRed = const Color(0xFFFF0000);
  Color customGreen = const Color(0xFF00FF00);
  Color customBlue = const Color.fromARGB(255, 35, 63, 100);
  Color customLightBlue = const Color.fromARGB(255, 133, 168, 229);
  Color customYellow = const Color(0xFFFFFF00);



  LinearGradient blackToMidnightBlue = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.5, 1.0],
    colors: [
      Color(0xFF000000),
      Color.fromARGB(255, 35, 63, 100),
    ],
  );

  /// Default color is [customWhite] or [0xFFFFFFFF]
  TextStyle darkOnWhiteTextXL = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFFFFF),
  );

  /// Default color is [customWhite] or [0xFFFFFFFF]
  TextStyle darkOnWhiteTextL = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFFFFFF),
  );

  /// Default color is [customWhite] or [0xFFFFFFFF]
  TextStyle darkOnWhiteTextM = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );

  /// Default color is [customWhite] or [0xFFFFFFFF]
  TextStyle darkOnWhiteTextS = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );

  /// Default color is [customWhite] or [0xFFFFFFFF]
  TextStyle darkOnWhiteTextXS = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );


}