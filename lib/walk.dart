import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gbetche/values/stringValues.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homeBottom.dart';
import 'main.dart';

///
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    /// Hive
    ///
    box_settings.put(Hive_Box_key.Settings, true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeBottomPage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Container(
      margin: const EdgeInsets.only(left:15.0, right:15.0, top:20, bottom : 10),
      child: Image.asset('assets/walk/$assetName', width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(

      key: introKey,
     // globalBackgroundColor: Colors.orangeAccent,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,

      globalHeader: Container(height: 34,color: Colors.orangeAccent,),
      pages: [
        /// 1
        /// style: GoogleFonts.lato(),
        PageViewModel(
          titleWidget: Text(
            "Connexion Culturelle : Sous-titrage de Vidéos de l'Anglais-Français en Fon",
            style: GoogleFonts.acme(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          bodyWidget: Text(
            "Découvrez comment rendre accessible des vidéos dans notre langue locale, le Fon, à partir de l'anglais et du français",
            style: GoogleFonts.actor(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          ///image: _buildImage('Freelancer.gif'),
          image: _buildImage('1.png'),
          decoration: pageDecoration,
        ),

        /// 2
        PageViewModel(
          titleWidget: Text(
            "Hub de Traduction en Temps Réel : Du Fon vers les Langues Mondiales comme l'Anglais et le Français",
            style: GoogleFonts.acme(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          bodyWidget: Text(
            "Explorez notre model de traduction en direct, facilitant la communication entre le Fon et les principales langues mondiales.",
            style: GoogleFonts.actor(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          image: _buildImage('2.png'),
          decoration: pageDecoration,
        ),

        /// 3
        PageViewModel(
          titleWidget: Text(
            "Visualisation Vocale : Génération d'Images Assistée par IA à partir des Langues Locales comme le Fon",
            style: GoogleFonts.acme(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          bodyWidget: Text(
            "Découvrez comment notre IA donne vie à des images à partir de langues locales telles que le Fon, révolutionnant la manière dont nous visualisons la communication.",
            style: GoogleFonts.actor(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          image: _buildImage('3.png'),
          decoration: pageDecoration,
        ),

        /// 4
        PageViewModel(
          titleWidget: Text(
            "Éducation Inclusive : Retranscription de Vidéos Françaises dans les Langues Locales comme le Fon",
            style: GoogleFonts.acme(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          bodyWidget: Text(
            "Découvrez vos programmes de formation novateur qui rend accessible le contenu éducatif français aux locuteurs du Fon et d'autres langues locales.",
            style: GoogleFonts.actor(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          image: _buildImage('4.png'),
          decoration: pageDecoration.copyWith(
            bodyFlex: 6,
            imageFlex: 6,
            safeArea: 80,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      doneStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      skipStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      baseBtnStyle: ButtonStyle(
          iconColor: MaterialStateProperty.all<Color>(Colors.black)),

      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Sauter',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Terminer',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        //color: Color(0xFFBDBDBD),
        color: Colors.green,
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.white,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),

      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.lightGreenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
