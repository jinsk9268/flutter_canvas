import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant.dart';

import './main_home.dart';

void main() {
  runApp(CanvasMobile());
}

class CanvasMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '캔버스 :: 당신의 색깔을 담은 주얼리',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cursorColor: brightBlackColor,
        primaryColor: brightBlackColor,
      ),
      home: MainHome(),
    );
  }
}
