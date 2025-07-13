import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  AppTheme._();//user shall not be able to access out themme so private constructor


  static ThemeData lightTheme = ThemeData( 
    primarySwatch: Colors.yellow,
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    // appBarTheme: AppBarTheme(),
    // outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    // elevatedButtonTheme:TElevatedButtonTheme.lightElevatedButtonTheme,
    // floatingActionButtonTheme: FloatingActionButtonThemeData(),
    // inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );


  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.yellow,
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    // appBarTheme: AppBarTheme(),
    // outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    // elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    // floatingActionButtonTheme: FloatingActionButtonThemeData(),
    // inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}

class TTextTheme {
  TTextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    headlineMedium: GoogleFonts.montserrat(color: Colors.black87),
    bodySmall: GoogleFonts.poppins(color: Colors.black, fontSize: 24),
  );
  static TextTheme darkTextTheme = TextTheme(
    headlineMedium: GoogleFonts.montserrat(color: Colors.white),
    bodySmall: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
    bodyMedium: GoogleFonts.poppins(color:Colors.white,),
  );
}