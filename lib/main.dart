import 'package:flutter/material.dart';
import 'package:gbetche/splash.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbetche/values/stringValues.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'model/pref_model.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;
import 'package:dart_openai/dart_openai.dart';

/*
void main() {
  runApp(const MyApp());
}
*/


Future<void> main() async {
  ///void main() {

  WidgetsFlutterBinding.ensureInitialized();

  /// Languge
  await langdetect.initLangDetect();

  ///
  ///const apiKey = "sk-proj-e8WKbU4c3Nps9iD11QalT3BlbkFJPSCRaJ9HoCYMypEp3jOs";
  ///const apiKey = "sk-proj-ZVDICBGBkoOa23aWqRgYT3BlbkFJt76VLrp6sXZhteeYRGFS";
  const apiKey = "sk-proj-PndTvjDVj2iG937Cf25iT3BlbkFJBeQAr1gWxdyzzrk2Vv3d";
  OpenAI.apiKey = apiKey;
  //OpenAI.requestsTimeOut = Duration(seconds: 60); // 60 seconds.
  //OpenAI.baseUrl = "https://api.openai.com/v1"; // the default one.
  OpenAI.baseUrl = "https://api.openai.com"; // the default one.
  OpenAI.showLogs = true;

  /// Hive
  /// Save Adaptateur
  await Hive.initFlutter();
  Hive.registerAdapter(ProfilPreferenceModelAdapter());

  box_preference = await Hive.openBox(Hive_Box.Preference);
  box_settings = await Hive.openBox(Hive_Box.Settings);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GBETCHE",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home:  Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}


///
/// Hive
///
//  Box? box_preference;
//  Box? box_settings;

late Box box_preference;
late Box box_settings;
late Box box_jour;




