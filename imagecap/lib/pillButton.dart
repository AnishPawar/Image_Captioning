import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  RoundButton({this.btn_color, this.onPressed});

  // Icon btn_icon;
  Color btn_color;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: btn_color,
      child: Text(
        "Copy to Clipboard",
        style: GoogleFonts.sourceSansPro(),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }
}
