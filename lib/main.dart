
import 'package:depp_reco/audio_recoreder_screen.dart';
import 'package:depp_reco/home_page.dart';
import 'package:depp_reco/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';


final ValueNotifier<double> valueNotifier = ValueNotifier(0);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    print(PhoneState.nothing().status == PhoneStateStatus.NOTHING);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PhoneState.nothing().status == PhoneStateStatus.NOTHING ? WelcomeScreen() : RecordingScreen(),
    );
  }
}

