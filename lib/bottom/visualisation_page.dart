import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';


import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;


import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:http/http.dart' as http;



class VisualisationPage extends StatefulWidget {
  const VisualisationPage({super.key});

  @override
  State<VisualisationPage> createState() => _VisualisationPageState();
}

///
/// Todo
///  1- Record Audio FONGBE ________________ Test Fongbe
///  2- Get FONGBE Traduction Fongbe _______ Traduction Anglais
///  3- Traduit Text Fongbe en Français ____ Generate Image
///  4- Genere Image with AI
///

///====>>> Fongbe Audio ==> Fongbe Text

class _VisualisationPageState extends State<VisualisationPage> {

  TextEditingController controller_description = TextEditingController();
  TextEditingController controller_objet = TextEditingController();



  ///
  bool startRecord = false;

  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  //bool _isRecording = false;
  //late String _filePath;


  /// Audio record
 // final record = AudioRecorder();
  bool showPlayer = false;
  String? audioPath;

  ///
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  /// Text To Audio
  FlutterTts flutterTts = FlutterTts();

  ///
  /// String _lastWords = "";
  String _lastWords = "";
  String _fongbe = "Visualisation en Fongbe";

  ///
  /// Initializes the [StabilityAI] class from the 'brain_fusion' package.
  final StabilityAI _ai = StabilityAI();

  /// This is the api key from stability.ai or https://dreamstudio.ai/, Create yours and replace it here.
  final String apiKey = 'sk-8CKyO68JlEY3RMAcPHhc90PAf8GgTV8UCL1ZnXK1LHGii8HV';

  /// This is the style [ImageAIStyle]
  final ImageAIStyle imageAIStyle = ImageAIStyle.noStyle;

  /// The boolean value to run the function.
  bool run = false;

  /// The [_generate] function to generate image data.
  Future<Uint8List> _generate(String query) async {
    /// Call the generateImage method with the required parameters.
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

  @override
  void initState() {
    showPlayer = false;

    super.initState();
    ///_initSpeech();
    _init(full_path: "/storage/emulated/0/Download/");
  }

  /// Speak
  flutter_speak({required String text}) async {
    await flutterTts.speak(text);
  }

  /// Speak
  flutter_stop() async {
    await flutterTts.stop();

    ///
    Fluttertoast.showToast(
        msg: "Le code de langue n'est pas encore pris en compte, or The language code is not yet taken into account.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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
      /// Text Audio
      _lastWords = result.recognizedWords;

      ///
      if (_lastWords.isNotEmpty) {
        /// If the user input is not empty, set [run] to true to generate the image.
        run = true;
      } else {
        /// If the user input is empty, print an error message.
        if (kDebugMode) {
          print('Query is empty !!');
        }
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
      flutter_speak(text: chaines);
    } else if (language == "fr") {
      /// Traduction
      flutter_speak(text: chaines);
    } else {
      ///
      Fluttertoast.showToast(
          msg:
              "Le code de langue $language n'est pas encore pris en compte, or The language code $language is not yet taken into account.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    print('Detected language: $language'); // -> "en"
  }

  @override
  Widget build(BuildContext context) {
    ///print(startRecord);

    /// The size of the container for the generated image.
    final double size = Platform.isAndroid || Platform.isIOS
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ///
            ///
            /// Image Generer
            ///
            Expanded(
              flex: 4,
              child: Container(
                ///color: Colors.red,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    // Align content vertically
                    children: [
                      /// Image
                      /*   Container(
                        // color: Colors.greenAccent,
                        color: Colors.red,
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/walk/Freelancer.gif"),
                      ),
                  */

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: run == true
                            ? FutureBuilder<Uint8List>(
                                /// Call the [_generate] function to get the image data.
                                future: _generate(_lastWords),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    /// While waiting for the image data, display a loading indicator.
                                    return Center(
                                      child: CupertinoActivityIndicator(
                                        animating: true,
                                        color: Colors.green,
                                        radius: MediaQuery.of(context).size.width < 800
                                            ? MediaQuery.of(context).size.width * 0.2
                                            : MediaQuery.of(context).size.height * 0.005,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    /// If an error occurred while getting the image data, display an error message.
                                    return Text( "Une erreur s'est produite durant le chargement : "+'Error: ${snapshot.error.toString().substring(30)}', style: TextStyle(
                                      color: Colors.red, fontWeight: FontWeight.bold,fontSize: 18
                                    ),);
                                  } else if (snapshot.hasData) {
                                    /// If the image data is available, display the image using Image.memory().
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(snapshot.data!),
                                    );
                                  } else {
                                    /// If no data is available, display a placeholder or an empty container.
                                    return Container();
                                  }
                                },
                              )
                            : Column(
                              children: [
                                Center(
                                    child: Text(
                                      _fongbe,
                                      style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                Image.asset("assets/walk/Freelancer.gif")
                              ],
                            ),
                      ),

                      /// Size Button
                      /*
                Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// Generate
                            /*
                            Expanded(
                                child: Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {

                                      },
                                      icon: Icon(
                                        Icons.play_circle_rounded,
                                        size: 50,
                                      ),
                                      color:Colors.orange,
                                    ),
                                  ),
                                )),
                            */

                            /// Partager
                            Expanded(
                                child: Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ///
                                    });
                                  },
                                  icon: Icon(
                                    Icons.share,
                                    size: 50,
                                  ),
                                  color: Colors.orange,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      */
                    ],
                  ),
                ),
              ),
            ),

            ///
            ///  Recorder
            ///  FONGBE
            ///
            Expanded(
              flex: 3,
              child: Container(
                //color: Colors.yellow,
                height: MediaQuery.of(context)
                    .size
                    .height, // Set height to full screen
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      /// ///
                     /* Center(
                        child: Container(
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
                      */


                      /// Record New
                  /*
                      Center(
                        child: showPlayer
                            ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: AudioPlayer(
                            source: audioPath!,
                            onDelete: () {
                              setState(() => showPlayer = false);
                            },
                          ),
                        )
                            : Recorder(
                          onStop: (path) {
                            if (kDebugMode) print('Recorded file path: $path');
                            setState(() {
                              audioPath = path;
                              showPlayer = true;
                            });
                          },
                        ),
                      ),
                      */



                      /// Button
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            /// Generer
                            Expanded(
                                child: Container(
                                 // color: Colors.red,
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextButton(

                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)) ,
                                      child:  Text(
                                        "      Générer     ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                                      onPressed: run == false ? () {
                                        setState(() {

                                          if (controller_description.text.isNotEmpty)
                                            {
                                              /// Generation

                                              print("Hello");
                                              convertEnFrToTextFn(langue: fon_en,phrase: controller_description.text );

                                            }
                                        });
                                      } : null,

                                    ),
                                  ),
                                )),

                            /// Effaccer
                            Expanded(
                                child: Container(
                                 // color: Colors.red,
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)) ,
                                      child:  Text(
                                        "      Effacer     ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                                      onPressed: () {
                                        setState(() {

                                          controller_description.clear();
                                          run = false;

                                        });
                                      },

                                    ),
                                  ),
                                )),

                          ],
                        ),
                      ),


                      /// Description
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        //color: Colors.red, height: 100,
                        child:  Container(
                          margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
                          padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Description
                                SizedBox(
                                  // color: Colors.orange,
                                  // height: 150,
                                  // width: 200,
                                  width: MediaQuery.of(context).size.width * 0.95,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [

                                      /// Prompte
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          minLines: 4,
                                          maxLines: 10,
                                          keyboardType: TextInputType.text,
                                          // enabled: ((auteur!.isAdmin  == true) || (auteur!.isComptable  == true) ),
                                          controller: controller_description,
                                          autovalidateMode: AutovalidateMode.always,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 15.0, horizontal: 10.0),
                                            /*icon: const Icon(
                                              Icons.video_stable_outlined,
                                              color: Colors.green,
                                            ),*/
                                            labelText: "Une phrase en fongbé",
                                            labelStyle: const TextStyle(color: Colors.black),
                                            hintText: "Décrivez ...",
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          onSaved: (String? value) {
                                            // This optional block of code can be used to run
                                            // code when the user saves the form.


                                          },
                                          onTap: (){
                                            setState(() {
                                              run = false;
                                            });
                                          },
                                          validator: (String? value) {
                                            return
                                              value?.isNotEmpty == false
                                                  ? "Une phrase en fongbé"
                                                  : null;
                                          },
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                              ]),
                        ),),


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: true,
        child: Padding(
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
            child:
            /*
            GestureDetector(
             // /*
              onTap: (){

                print("AUDIO FON");
              ///  convertEnFrToTextFnAudio(path: "/storage/emulated/0/Download/AI.wav");
                // test( "/storage/emulated/0/Download/AI.wav");
                test( "/storage/emulated/0/Download/v11.wav");
              setState(() {

              });
                },

              // */
              /*

              onTapDown: (value) {
                setState(() {
                  startRecord = true;
                });

                _startListening();

                ///

                //_speechToText.isNotListening ? _startListening : _stopListening;

                ///
                if (_speechEnabled) {
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
              */
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
            */
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  ElevatedButton(
                    onPressed: (){
                      _currentStatus == RecordingStatus.Recording ? _stop :
                      _start;
                    },
                    child: Text(_currentStatus == RecordingStatus.Recording ? 'Stop Recording' : 'Start Recording'),
                  ),


                  /// Upload
                  if ( (_currentStatus != RecordingStatus.Recording) && (_current!.path != null))
                    ElevatedButton(
                      onPressed: (){
                       /// test( "/storage/emulated/0/Download/v11.wav");
                       // Source source = DeviceFileSource(_current!.path!);
                        test( _current!.path.toString());
                      },
                      child: Text('Upload File'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  ///
  ///
  Future<String> AudioFonToTextFon({ required String filename}) async {
    String transcription = "";

    ///
    final headers = {
      'Authorization': 'Bearer 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',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final url = Uri.parse('https://api-inference.huggingface.co/models/speechbrain/asr-wav2vec2-dvoice-fongbe');

    var response ;
    final data = await File(filename).readAsBytesSync();
    response  = await http.post(url, headers: headers, body: data);

    print(await File(filename).path);
    print(await File(filename).parent);
    print(await File(filename).isAbsolute);
    print(await File(filename).readAsBytes());

    /*
    final response = await http.post(
      Uri.parse("https://api-inference.huggingface.co/models/speechbrain/asr-wav2vec2-dvoice-fongbe"),
      headers: {"Authorization": "Bearer ${API_TOKEN}"},
      body: data,
    );
     */


    /// final responseData = json.decode(newresponse.body);
   // final responseData = json.decode(newresponse.text);
   // return responseData['text'];

   // if (response.statusCode == 200) {
    if (response.statusCode == 200) {

      transcription = json.decode(response.body);


      setState(() {
        Fluttertoast.showToast(
            msg: transcription.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });

    }
    else {
      print("${response.reasonPhrase} ${response.statusCode}");

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

    return jsonDecode(response.body);


    Fluttertoast.showToast(
        msg: "Audio transferer avec succes Ai",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);


  }



  final String en_fon = "en-fon";
  final String fr_fon = "fr-fon";
  final String fon_fr = "fon-en";
  final String fon_en = "fon-fr";

  /// Traduction Fon
  Future<String> convertEnFrToTextFn({required String phrase, required String langue, String path = "", } ) async{
    String reponse = "";


    var request = http.Request('POST', Uri.parse('https://translate-api-f4bl.onrender.com/translate/$langue?sentence=$phrase'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     /// print(await response.stream.bytesToString());
      await response.stream.bytesToString().then((value) {
        reponse = value ;

        setState(() {
          _lastWords = value ;
          run = true;
          print(value);
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

      setState(() {

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

  /// Traduction Fon Text Audio
  Future<String> convertEnFrToTextFnAudio({ required String path} ) async{

    String reponse = "";
    final data = await File(path).readAsBytes();

    var request = http.Request('POST', Uri.parse('https://gbetche-transcriber.onrender.com/audio-fon',),);


     http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     /// print(await response.stream.bytesToString());
      await response.stream.bytesToString().then((value) {
        reponse = value ;


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

        print(onError.name);
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



  /// Version correct Audio Fongbe vers Text Fongbe
  void test(String path) async {
    var url = Uri.parse('https://gbetche-transcriber.onrender.com/audio-fon');
    var filePath = path; // Remplacez par le chemin réel de votre fichier

    var request = http.MultipartRequest('POST', url)
      ..headers['accept'] = 'application/json'
      ..headers['Content-Type'] = 'multipart/form-data'
      ..files.add(await http.MultipartFile.fromPath(
        'audio',
        filePath,

        ///contentType: MediaType('audio', 'wav'),
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      print('Success: $responseData');

      // Attendre que la réponse complète soit disponible
      var responseDataSuite = await http.Response.fromStream(response);

      // Vérifier si le contenu est du JSON
      if (responseDataSuite.headers['content-type']?.contains('application/json') ?? false) {
        print('Success: ${responseDataSuite.body}');
      } else {
        print('Failed: Unexpected content type');
      }

    } else {
      print('Failed with status: ${response.statusCode}');
    }
  }


  @override
  void dispose() {
    super.dispose();
  }


  _init({required String full_path}) async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
       /// String customPath = '/another_audio_recorder_';

       io.Directory appDocDirectory;
       /* if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }
        */

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        ///customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();
        String customPath = full_path + DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);
        ///_recorder = AnotherAudioRecorder(full_path, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        // after initialization
        var current = await _recorder?.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
      } else {
        return SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder?.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder?.pause();
    setState(() {});
  }




  _stop() async {
    var result = await _recorder?.stop();

    print("Stop recording: ${result?.path}");
    print("Stop recording: ${result?.duration}");

   // File file = widget.localFileSystem.file(result?.path);
    File file = File(result!.path.toString());
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
  }



}
