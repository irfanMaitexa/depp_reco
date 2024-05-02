import 'dart:collection';

import 'package:depp_reco/api/apis.dart';
import 'package:depp_reco/audio_recoreder_screen.dart';
import 'package:depp_reco/upload_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:depp_reco/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedFilePath;

  final _apiServices = ApiServices();

  Map<String,dynamic>  ? data;

  bool loading = false;

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
        setState(() {
          loading = true;
        });
        PlatformFile file = result.files.first;
        String filePath = file.path!;

        selectedFilePath = filePath;

        try{


           data =   await _apiServices.sendAudioFile(selectedFilePath!);

         print(data);

         

        valueNotifier.value = data!['probability_real'];

        setState(() {
          loading = false;
        });

        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioUploadScreen(
                  gender: data!['Gender Identify'],
                  outPut: data!['Output'],
                  prediction: data!['prediction'],

                ),
              ));
        }

        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

        }
      } else {}
    } else {
      await Permission.storage.request();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkAndRequestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff032129),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'Voice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Detection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Find your voice fake or not',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/s.png',
                    )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(92, 138, 138, 138),
                            borderRadius: BorderRadius.circular(25)),
                        child:  ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RecordingScreen(),));
                            
                          },
                          title: Text(
                            'Record',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'Record your audio',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.record_voice_over,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Opacity(
                      opacity: 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(92, 138, 138, 138),
                            borderRadius: BorderRadius.circular(25)),
                        child: ListTile(
                          onTap: () {
                            pickAudioFile();
                          },
                          title: const Text(
                            'Upload',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: const Text(
                            'upload your audiofile',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.file_upload_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ))
              ],
            ),
    );
  }
}
