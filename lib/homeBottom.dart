

import 'package:flutter/material.dart';

import 'package:gbetche/bottom/traduction_page.dart';
import 'package:gbetche/bottom/transcription_page.dart';
import 'package:gbetche/bottom/visualisation_page.dart';
import 'package:gbetche/walk.dart';
import 'package:cuberto_bottom_bar/cuberto_bottom_bar.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'bottom/education_page.dart';



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

  // final Color _inactiveColor = Colors.lightBlue;
  final Color _inactiveColor = Colors.lightGreen;
  Color _currentColor = Colors.green;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {

    /// Page
    List<Widget> _pages = <Widget>[
      TranscriptionPage(),
      TraductionPage(),
      VisualisationPage(),
      EducationPage(),
    ];


    return Scaffold(
      /* body: Center(
      child: Text(
      _currentTitle,
      style: TextStyle(fontWeight: FontWeight.bold, color: _currentColor),
    ),
    ),
      */
      body: Center(
        child: _pages[_currentPage],
      ),

      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentPage,
        onTap: (i) => setState(() => _currentPage = i),
        items: [

          /// Trascription
          SalomonBottomBarItem(
            icon: Icon(Icons.subtitles_outlined),
            title: Text("Trascription"),
            selectedColor: Colors.green,
          ),

          /// Traduction
          SalomonBottomBarItem(
            icon: Icon(Icons.translate_sharp),
            title: Text("Traduction"),
            selectedColor: Colors.pink,
          ),

          /// Visualisation
          SalomonBottomBarItem(
            icon: Icon(Icons.image_sharp),
            title: Text("Visualisation"),
            selectedColor: Colors.orange,
          ),

          /// Éducation
          SalomonBottomBarItem(
            icon: Icon(Icons.school_outlined),
            title: Text("Éducation"),
            selectedColor: Colors.teal,
          ),


        ],
      ),

      /*
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconSize: 40,
        mouseCursor: SystemMouseCursors.grab,
        selectedFontSize: 20,
        selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 40),
        selectedItemColor: Colors.amberAccent,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _currentPage,
        unselectedIconTheme: IconThemeData(
          color: Colors.deepOrangeAccent,
        ),
        unselectedItemColor: Colors.deepOrangeAccent,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Emails',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),

      */
      /*
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
      */
    );
  }





  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
  }
}



