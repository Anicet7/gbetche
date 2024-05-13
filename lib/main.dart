import 'package:flutter/material.dart';
import 'package:gbetche/splash.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbetche/values/stringValues.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'model/pref_model.dart';

/*
void main() {
  runApp(const MyApp());
}
*/


Future<void> main() async {
  ///void main() {

  WidgetsFlutterBinding.ensureInitialized();

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




