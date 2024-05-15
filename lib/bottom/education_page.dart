import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.white,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Coming soon...",
            textAlign: TextAlign.left,
            style: GoogleFonts.abel(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),

        ),
      ),),) ;
  }
}
