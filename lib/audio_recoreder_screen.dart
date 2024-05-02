import 'dart:async';
import 'dart:math';

import 'package:depp_reco/api/apis.dart';
import 'package:depp_reco/main.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isRecording = false;
  late final AudioRecorder _audioRecorder;
  String? _audioPath;
  bool isLoad = false;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      debugPrint(
          '=========>>>>>>>>>>> RECORDING!!!!!!!!!!!!!!! <<<<<<===========');

      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');

      await _audioRecorder.start(
        const RecordConfig(
          // specify the codec to be `.wav`
          encoder: AudioEncoder.wav,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('ERROR WHILE RECORDING: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();

      setState(() {
        _audioPath = path!;

        isLoad = true;

        
      });

       await ApiServices().sendAudioFile(_audioPath!);

        valueNotifier.value = 90;



      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          isRecording = true;
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
        // TODO: handle this case
      }
    } else {
      await _stopRecording();

      setState(() {
        isRecording = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff032129),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:  CustomRecordingButton(
            isRecording: isRecording,
            onPressed: () => _record(),
          ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Record',style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: <Widget>[
          isRecording ? const CustomRecordingWaveWidget() : Center(child: Text('just tap on button record your audio',style: TextStyle(color: Colors.white),)),
          const SizedBox(height: 16),

          
          
         
        ],
      ),
    );
  }
}

class CustomRecordingButton extends StatelessWidget {
  const CustomRecordingButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  final bool isRecording;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 100,
      width: 100,
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(
        isRecording ? 25 : 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.green,
          width: isRecording ? 8 : 3,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 29, 197, 34),
          shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
        ),
        child: MaterialButton(
          onPressed: onPressed,
          shape: const CircleBorder(),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class CustomRecordingWaveWidget extends StatefulWidget {
  const CustomRecordingWaveWidget({super.key});

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  final List<double> _heights = [0.05, 0.07, 0.1, 0.07, 0.05];
  Timer? _timer;

  @override
  void initState() {
    _startAnimating();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimating() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        // This is a simple way to rotate the list, creating a wave effect.
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _heights.map((height) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: MediaQuery.sizeOf(context).height * height,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 255, 10),
              borderRadius: BorderRadius.circular(50),
              
            ),
          );
        }).toList(),
      ),
    );
  }
}
