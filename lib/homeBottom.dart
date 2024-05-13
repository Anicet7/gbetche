

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gbetche/walk.dart';
import 'dart:async';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gradient_color.dart';


class HomeBottomPage extends StatefulWidget {
  const HomeBottomPage({super.key});

  @override
  State<HomeBottomPage> createState() => _HomeBottomPageState();
}

class _HomeBottomPageState extends State<HomeBottomPage> {

  ///
  void _onBackToIntro(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnBoardingPage()),
    );
  }


  List<TabData> tabs = [];
  final Color _inactiveColor = Colors.lightBlue;
  Color _currentColor = Colors.blue;
  int _currentPage = 0;
  late String _currentTitle;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabData(
        iconData: Icons.home,
        title: "Home",
        tabColor: Colors.deepPurple,
        tabGradient: getGradient(Colors.deepPurple),
      ),
      TabData(
        iconData: Icons.search,
        title: "Search",
        tabColor: Colors.pink,
        tabGradient: getGradient(Colors.pink),
      ),
      TabData(
        iconData: Icons.alarm,
        title: "Alarm",
        tabColor: Colors.amber,
        tabGradient: getGradient(Colors.amber),
      ),
      TabData(
        iconData: Icons.settings,
        title: "Settings",
        tabColor: Colors.teal,
        tabGradient: getGradient(Colors.teal),
      ),
    ];
    _currentTitle = tabs[0].title;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
      child: Text(
      _currentTitle,
      style: TextStyle(fontWeight: FontWeight.bold, color: _currentColor),
    ),
    ),
      bottomNavigationBar: CubertoBottomBar(
        key: const Key("BottomBar"),
        inactiveIconColor: _inactiveColor,
        tabStyle: CubertoTabStyle.styleNormal,
        selectedTab: _currentPage,
        tabs: tabs
            .map(
              (value) => TabData(
            key: Key(value.title),
            iconData: value.iconData,
            title: value.title,
            tabColor: value.tabColor,
            tabGradient: value.tabGradient,
          ),
        )
            .toList(),
        onTabChangedListener: (position, title, color) {
          setState(() {
            _currentPage = position;
            _currentTitle = title;
            if (color != null) {
              _currentColor = color;
            }
          });
        },
      ),
    );
  }


}



