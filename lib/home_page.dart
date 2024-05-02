import 'dart:convert';

import 'package:depp_reco/api/apis.dart';
import 'package:depp_reco/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_audio/tflite_audio.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String? selectedFilePath;
  bool isRecording = false;
  late AnimationController _controller;
  late Animation<double> _animation;
   final String inputType = 'rawAudio';


  final ApiServices _apiServices = ApiServices();

  


   loadmodel() async {

  
    // interpreter = await  tfl.Interpreter.fromAsset('assets/model.tflite');

    await  TfliteAudio.loadModel(
      model: 'assets/model.tflite',
      label: 'assets/metadata.txt',
      inputType: 'rawAudio',
      );

      print('hhhhhhh');



    
    
  }

  @override
  void initState() {
    super.initState();
    


    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create a curved animation with a repeating reverse animation
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }


   Map<String,dynamic> ? data;




  void _checkAndRequestPermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status != PermissionStatus.granted) {
      await Permission.storage.request();
    }
  }

  void pickAudioFile() async {
    PermissionStatus status = await Permission.storage.status;

    if (status == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String filePath = file.path!;


        setState(() {
          selectedFilePath = filePath;
          startRecording();
          _controller.repeat(reverse: true);


          
        });

        // if (context.mounted) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => AudioPlayerPage(
        //           filePath: filePath,
        //         ),
        //       ));
        //}
      } else {
        stopRecording();
      }
    } else {
      await Permission.storage.request();
    }
  }

  //get data from api
  Future<void> getData() async {
    try {

      startRecording();
      data = await _apiServices.sendAudioFile(selectedFilePath!);

     print("dddddddddddddddddddddddddddddd");
      print(data);

      

      
        stopRecording();
        _controller.stop();
        
      
    } catch (e) {
      if(context.mounted){
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Somthing went wrong')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ScaleTransition(
              scale: _animation,
              child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording ? Colors.red : Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      size: 40,
                      color: Colors.white,
                    ),
                  )),
            ),

            const Spacer(
              flex: 2,
            ),

            isRecording
                ? SizedBox(
                    width: 50,
                    child: LoadingAnimationWidget.stretchedDots(
                      color: Colors.red,
                      size: 60,
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: const Size.fromHeight(50)),
                        onPressed: () async {
                          pickAudioFile();

                        
                        },
                        child: const Text(
                          'Start',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: const Size.fromHeight(50)),
                        onPressed: () async {

                          try{

                            data =   await  _apiServices.sendAudioFile(selectedFilePath!);

                            print(data);
                            valueNotifier.value = 90;


                          }catch(e){




                          }

                        
                        },
                        child: const Text(
                          'Start',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            


            // if (selectedFilePath != null)
            //   Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Text(
            //       'Selected File: $selectedFilePath',
            //       style: const  TextStyle(fontSize: 16),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  void startRecording() {
    setState(() {
      isRecording = true;
    });
  }

  void stopRecording() {
    setState(() {
      isRecording = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
