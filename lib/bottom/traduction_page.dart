import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

// recommend to import 'as langdetect' because this package shows a simple function name 'detect'
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;
import 'package:http/http.dart' as http;


class TraductionPage extends StatefulWidget {
  const TraductionPage({super.key});

  @override
  State<TraductionPage> createState() => _TraductionPageState();
}


///
/// Todo
///  1- Record Audio French English
///  2- Traduction French English ---> Fongbe
///  3- Traduit Text Fongbe ---> Audio Fongbe
///

class _TraductionPageState extends State<TraductionPage> {


  ///
  bool startRecord = false;
  bool play_stat = false;
  bool play_stop = false;

  /// Text To Audio
  FlutterTts flutterTts = FlutterTts();

  ///
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;


  ///
  ///String _init_world_fongbe = "Cliquez sur l'icône de lecture pour écouter la traduction audio en fon.\n or \nClick the play icon to listen to the audio translation in fon.";
  String _init_world_fongbe = "La traduction en fon";

  ///
  //String _lastWords = "";
  String _lastWords =
      "Appuyez sur le micro pour commencer à enregistrer la parole en français ou anglais \n or \nTap the mic to start recording speech in french or english";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// Speak
  flutter_speak({required String text}) async {
    await flutterTts.speak(text);
  }

  /// Speak
  flutter_stop() async {
    await flutterTts.stop();


  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;


      String codeLangue = langdetect.detect(_lastWords);
      if (codeLangue == "en") {
        convertEnFrToTextFn(phrase: _lastWords, langue: en_fon);
      }else if (codeLangue == "fr")
        {
          convertEnFrToTextFn(phrase: _lastWords, langue: fr_fon);
        }


    });
  }

  ///
  /// Traitement
  ///
  void getLangueGenerateAudio({required String chaines}) {
    final language = langdetect.detect(chaines);
    if (language == "en") {
      /// Traduction
      ///flutter_speak(text: chaines);
      convertEnFrToTextFn(phrase:  chaines,langue: en_fon).then((value) => flutter_speak(text: value));


    } else if (language == "fr") {
      /// Traduction
      /// flutter_speak(text: chaines);
      convertEnFrToTextFn(phrase:  chaines,langue: fr_fon).then((value) => flutter_speak(text: value));

    } else {

      ///
      Fluttertoast.showToast(
          msg: "Le code de langue $language n'est pas encore pris en compte, or The language code $language is not yet taken into account.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      /// Traduction
      flutter_speak(text: chaines);
      ///convertEnFrToTextFn(phrase:  chaines,langue: fr_fon).then((value) => flutter_speak(text: value));


    }

    print('Detected language: $language'); // -> "en"
  }

  @override
  Widget build(BuildContext context) {
    print(startRecord);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          // Change to Column for vertical split
          children: [
            Expanded(
              flex: 2,
              child: Container(
                ///color: Colors.red,
                height: MediaQuery.of(context).size.height,
                // Set height to full screen
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    // Align content vertically
                    children: [
                      ///
                      Container(
                        // color: Colors.greenAccent,
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Fongbé",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.abel(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),

                      /// Bouton Play
                  /*
                  Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      play_stat = true;
                                      play_stop = false;

                                      if (play_stat == true) {
                                      ///  getLangueGenerateAudio(chaines: _lastWords);

                                        getLangueGenerateAudio(chaines: _lastWords);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.volume_up_rounded,
                                    size: 50,
                                  ),
                                  color: play_stat == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      play_stop = false;
                                      play_stat = false;

                                      if (play_stop == true) {
                                        flutter_stop();
                                      }

                                    });
                                  },
                                  icon: Icon(
                                    Icons.stop_circle_outlined,
                                    size: 50,
                                  ),
                                  color: play_stop == true
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      */

                      /// Text FonGbe
                      Center(
                        child: Container(
                          // color: Colors.greenAccent,
                          color: Colors.white,
                          padding: EdgeInsets.all(26),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Center(
                              child: Text(
                                // _init_world,
                                _init_world_fongbe,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.abel(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                /// color: Colors.yellow,
                height: MediaQuery.of(context)
                    .size
                    .height, // Set height to full screen
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    // Align content vertically
                    children: [
                      Center(
                        child: Container(
                          // color: Colors.greenAccent,
                          color: Colors.white,
                          padding: EdgeInsets.all(26),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Center(
                              child: Text(
                                // _init_world,
                                _lastWords,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.abel(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        ///padding: EdgeInsets.only(bottom: 85),
        // padding: EdgeInsets.only(bottom: 45),
        padding: EdgeInsets.only(bottom: 10),
        child: AvatarGlow(
          startDelay: const Duration(milliseconds: 1000),
          glowColor: Colors.green,
          glowShape: BoxShape.circle,
          animate: startRecord == true,

          ///animate: _speechToText.isListening ,
          curve: Curves.fastOutSlowIn,
          child: GestureDetector(
            onTapDown: (value) {
              setState(() {
                startRecord = true;
              });

              _startListening();

              ///

              //_speechToText.isNotListening ? _startListening : _stopListening;

              ///
              if (_speechEnabled) {
                /*
                _speechToText.listen(
                  onResult : (value){
                    setState(() {
                      text = value.recognizedWords;
                    });
                  }

                );
                */

                ///_onSpeechResult(_speechToText);
              }
            },
            onTapUp: (value) {
              setState(() {
                startRecord = false;
              });
              _stopListening();

              ///
              //_speechToText.isNotListening ? _startListening : _stopListening;

              _stopListening();

              ///_speechToText.stop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),

              /// child: Icon( startRecord == true ? Icons.mic : Icons.mic_off, color: Colors.white,),
              child: Icon(
                _speechToText.isNotListening ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
        ),
      ),
    );
  }



  final String en_fon = "en-fon";
  final String fr_fon = "fr-fon";
  final String fon_fr = "fon-en";
  final String fon_en = "fon-fr";

  /// Traduction Fon
  Future<String> convertEnFrToTextFn({required String phrase, required String langue, } ) async{
    String reponse = "";

    var request = http.Request('POST', Uri.parse('https://translate-api-f4bl.onrender.com/translate/$langue?sentence=$phrase'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      await response.stream.bytesToString().then((value) {reponse = value;
      _init_world_fongbe = value ;
      setState(() {

      });
      }).catchError((onError){
        setState(() {
          Fluttertoast.showToast(
              msg: onError.toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      });

    }
    else {
      print(response.reasonPhrase);
      setState(() {
        Fluttertoast.showToast(
            msg: response.reasonPhrase.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }

    return reponse;
  }

}
