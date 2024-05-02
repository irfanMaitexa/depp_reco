import 'package:depp_reco/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff032129),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              'Voice',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Detection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Find your voice fake or not',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Center(child: Image(image: AssetImage('assets/s.png'))),
            Spacer(),
            Center(
                child: SliderButton(
              action: () async {

                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                return true;
              },
              alignLabel: Alignment.center,
              backgroundColor: Color.fromARGB(255, 45, 58, 46),
              baseColor: const Color.fromARGB(255, 29, 197, 34),
              label: Text(
                "Get Started",
      
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
              icon:Icon(Icons.arrow_forward_ios,size: 16,)
            )),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
