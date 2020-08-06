import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './home_order.dart';

void main() {
  runApp(CanvasMobile());
}

class CanvasMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Canvas',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cursorColor: Color(0xff1D2433),
        primaryColor: Color(0xff1D2433),
      ),
      home: HomeOrder(),
    );
  }
}
