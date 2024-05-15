import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gbetche/values/stringValues.dart';
import 'package:gbetche/walk.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';

import 'homeBottom.dart';
import 'main.dart';
import 'model/pref_model.dart';


class Splash extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> with TickerProviderStateMixin {

  ///
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _animate = true;

  @override
  void initState() {
    // TODO: implement initState

    startTimer();
    _portraitModeOnly();
    _initAnimation();
    _animationController.forward();

    super.initState();

    if (kIsWeb == false) {
      requestPermission(Permission.videos);
      requestPermission(Permission.storage);
    }
  }

  // Screen orientation
  // blocks rotation; sets orientation to: portrait
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Animation
  // User
  void _initAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();

    _pulseAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _animationController.reverse();
      else if (status == AnimationStatus.dismissed)
        _animationController.forward();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Align(
                  alignment: Alignment.center,
                  child: AvatarGlow(
                    startDelay: const Duration(milliseconds: 1000),
                    glowColor: Colors.green,
                    glowShape: BoxShape.circle,
                    animate: _animate,
                    curve: Curves.fastOutSlowIn,
                    child: const Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      color: Colors.transparent,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/logo/logo.jpg'),
                        radius: 80.0,
                      ),
                    ),
                  ),
                ),

                /*
                  Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/logo/logo.jpg',
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width / 2,
                          // width: MediaQuery.of(context).size.width < 800  ?  MediaQuery.of(context).size.width * 0.6 :  MediaQuery.of(context).size.width * 0.3,
                        ),
                      )),
                  */
              ),
            ],
          ),
          //     Align(alignment: Alignment.bottomCenter,

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "GBETCHE",
                    style:
                    TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ]));
  }

  // Gestion du temps
  startTimer() async {
    // var duration = Duration (seconds: 5);  // Android Version
    var duration = Duration(seconds: 5);
    return Timer(duration, route);
  }

  route() {


    Box settings;
    // var reversed = settings.get('reversed', defaultValue: true) as bool;
    var reversed =  box_settings.get(Hive_Box_key.Settings, defaultValue: false) as bool ;

    ///*
    setState(() {
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: (reversed == true ) ? HomeBottomPage() : OnBoardingPage()));
    });
    ///*/



  }

  /// Permission
  Future<void> requestPermission(Permission permission) async {
    //
    final status = await permission.request();
  }
}
