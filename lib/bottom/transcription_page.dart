import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:video_player/video_player.dart';
import 'package:dart_openai/dart_openai.dart';

//___import 'package:learning/constant.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

class TranscriptionPage extends StatefulWidget {
  const TranscriptionPage({super.key});

  @override
  State<TranscriptionPage> createState() => _TranscriptionPageState();
}

/// Todo
/// 1- Lord video                 OK
/// 2- Video to Audio Wav         OK
/// 3- Push audio to APP NNL
/// 4- Get reponse text

class _TranscriptionPageState extends State<TranscriptionPage> {
  late VideoPlayerController _controller;

  /// Text
  String traduction_font = "";
  bool stat_traitement = false;

  @override
  void initState() {
    super.initState();

    _initSpeech();
    _copyAssetToLocal();

    /// _controller = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    _controller = VideoPlayerController.asset("assets/v1.mp4")
      ..initialize().then((_) {
        setState(() {});
        ConvertVideoToAudio().then((value) {
          //if () {

          const String BASE_PATH = '/storage/emulated/0/Download/';
          const String OUTPUT_PATH = BASE_PATH + 'v1.wav';

          convertSpeechToText(OUTPUT_PATH).then((value) {
            setState(() {
              stat_traitement = false;

              Fluttertoast.showToast(
                  msg: "Transcription succes ...",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);

              traduction_font = value;
            });
          }).onError((error, stackTrace) {
            traduction_font = "Erreur de chargement, veuillez réessayer";
            Fluttertoast.showToast(
                msg: error.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            print(error);
            stat_traitement = false;
          });

          // }
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            /// Titre
            /// Video
            Expanded(
              flex: 3,
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

                      /// Titre Fongbé
                      Container(
                        // color: Colors.greenAccent,
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Transcription en Fongbé",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.abel(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),

                      /// Video
                      Container(
                          // color: Colors.greenAccent,
                          color: Colors.white,
                          padding: EdgeInsets.all(18),
                          child: _controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                )
                              : CupertinoActivityIndicator(
                                  animating: true,
                                  color: Colors.green,
                                  radius: MediaQuery.of(context).size.width <
                                          800
                                      ? MediaQuery.of(context).size.width * 0.08
                                      : MediaQuery.of(context).size.height *
                                          0.005,
                                )),

                      /// Bouton
                      /// Play
                      /// Stop
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AvatarGlow(
                                      startDelay: const Duration(milliseconds: 1000),
                                      glowColor: Colors.orange,
                                      glowShape: BoxShape.circle,
                                      animate: _controller.value.isPlaying,
                                      curve: Curves.fastOutSlowIn,
                                      child: IconButton(
                                       onPressed: () {
                                       setState(() {


                                        _controller.value.isPlaying
                                            ? { _controller.pause(),_stopListening() }
                                            : {_controller.play(),  _startListening() };




                                      });
                                    },
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_circle,
                                      size: 40,
                                    ),
                                    color: _controller.value.isPlaying == true
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                    ),
                                  ),
                                )),
                            ///*
                              Expanded(
                                child: Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {

                                           /// _controller.pause();
                                          _pickVideo();

                                        });
                                      },
                                      icon: Icon(
                                        Icons.video_stable_outlined,
                                        size: 40,
                                      ),
                                      color: Colors.red,
                                    ),
                                  ),
                                )),
                          ///  */
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Transcription Font
            Expanded(
              flex: 2,
              child: stat_traitement == false
                  ? Container(
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
                                      _lastWords,
                                      ///traduction_font,
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
                    )
                  : CupertinoActivityIndicator(
                      animating: true,
                      color: Colors.green,
                      radius: MediaQuery.of(context).size.width < 800
                          ? MediaQuery.of(context).size.width * 0.08
                          : MediaQuery.of(context).size.height * 0.005,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Future<void> ConvertVideoToAudio() async {
    ///
    stat_traitement = true;

    const String BASE_PATH = '/storage/emulated/0/Download/';
    const String video1 = BASE_PATH + 'v1.mp4';
    const String OUTPUT_PATH = BASE_PATH +'v1.wav';

    if (await Permission.storage.request().isGranted) {
      ///String commandToExecute = '-i ${video1} -vn -acodec copy ${OUTPUT_PATH}';
      String commandToExecute = '-i ${video1} -vn -acodec copy -ss 00:00:00 -t 00:01:36 ${OUTPUT_PATH}';
      await FFmpegKit.execute(commandToExecute).then((session) async {
        final returnCodeS = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCodeS)) {
          Fluttertoast.showToast(
              msg: "Audio extrait avec succès",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          //  print('Audio extrait avec succès vers: $outputAudioPath');
        } else {

          stat_traitement = false;
          traduction_font = "Erreur de chargement, veuillez réessayer";

          Fluttertoast.showToast(
              msg: "Échec de l\'extraction audio",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          // throw Exception('Échec de l\'extraction audio : ${returnCodeS}');
        }
      });
    }
  }

  ///
  ///
  void _copyAssetToLocal() async {
    try {
      const String BASE_PATH = '/storage/emulated/0/Download/';
      var content = await rootBundle.load("assets/v1.mp4");
      var file = File("${BASE_PATH}v1.mp4");
      file.writeAsBytesSync(content.buffer.asUint8List());
    } catch (e) {
      ///
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  ///
  ///
  Future<String> convertSpeechToText(String filePath) async {
    OpenAIAudioModel transcription = OpenAI.instance.audio.createTranscription(
      file: File(filePath),
      model: "whisper-1",
      responseFormat: OpenAIAudioResponseFormat.json,

    ) as OpenAIAudioModel;

   // print the transcription.
    print(transcription.text);
    return transcription.text;
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
      await response.stream.bytesToString().then((value) =>  reponse = value).catchError((onError){
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


  Future<String> convertSpeechToTextSS(String filePath) async
  {

    const apiKey = "sk-proj-e8WKbU4c3Nps9iD11QalT3BlbkFJPSCRaJ9HoCYMypEp3jOs";
    var url = Uri.https("api.openai.com", "v1/audio/transcriptions");
    var request = http.MultipartRequest('POST', url);

    request.headers.addAll(({"Authorization": "Bearer $apiKey"}),);
    request.headers.addAll(({"Content-Type": "multipart/form-data"}),);
    request.fields["model"] = 'whisper-1';

    request.headers["Authorization"] = 'Bearer $apiKey';
    request.headers["Content-Type"] = 'multipart/form-data';

     request.fields["language"] = "en";
    //request.fields["language"] = "fr";
    request.files.add(await http.MultipartFile.fromPath('file', filePath,));
    var response = await request.send();
    var newresponse = await http.Response.fromStream(response)
        .then((value) {
      setState(() {


        Fluttertoast.showToast(
            msg: "Audio transferer avec succes Ai",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        stat_traitement = false;

      });
    })
        .onError((error, stackTrace) {

          setState(() {
            Fluttertoast.showToast(
                msg: error.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });

    });

    /// final responseData = json.decode(newresponse.body);
    final responseData = json.decode(newresponse.text);

    return responseData['text'];
  }




  ///
///
///

  ///
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

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
    });
  }



  /// Video Picker
  // Pick a video.
  final ImagePicker picker = ImagePicker();
  XFile? _videoFile ;

  Future<void> _pickVideo() async {

    final XFile? galleryVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (galleryVideo != null) {
      _videoFile = galleryVideo;
      _controller = VideoPlayerController.file(File(galleryVideo.path))
        ..initialize().then((_) {
          setState(() {});
         /// _controller.play();
        });
    }
  }

}
