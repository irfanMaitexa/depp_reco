import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:depp_reco/main.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';




// ignore: must_be_immutable
class AudioUploadScreen extends StatefulWidget {
   AudioUploadScreen({super.key,required this.gender, required this.outPut, required this.prediction});

  final String gender;

 final String  outPut;
  final String prediction;

  @override
  State<AudioUploadScreen> createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
 

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff090b12),
      appBar: AppBar(
        title: Text('Result',style: TextStyle(color: Colors.white,fontSize: 25),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
                child: CircularSeekBar(
              interactive: false,
              width: double.infinity,
              height: 250,
              progress: valueNotifier.value,
              barWidth: 8,
              startAngle: 45,
              sweepAngle: 270,
              strokeCap: StrokeCap.butt,
              progressGradientColors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple
              ],
              innerThumbRadius: 5,
              innerThumbStrokeWidth: 3,
              innerThumbColor: Colors.white,
              outerThumbRadius: 5,
              outerThumbStrokeWidth: 10,
              outerThumbColor: Colors.blueAccent,
              dashWidth: 1,
              dashGap: 2,
              animation: true,
              valueNotifier: valueNotifier,
              child: Center(
                child: ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${value.round()}%',
                                style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.w700)),
                            Text(widget.prediction,
                                style: TextStyle(color: Colors.white,fontSize: 20)),
                          ],
                        )),
              ),
            )),

            Expanded(child: Column(
              children: [

                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person,color: Colors.white,size: 50,),
                      title: Text(widget.gender,style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      leading: Icon(Icons.message,color: Colors.white,size: 50,),
                      title: Text(widget.outPut,style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ))

            // SizedBox(
            //   width: double.maxFinite,
            //   child: ElevatedButton.icon(onPressed: () {
              
            //     pickAudioFile();
                
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color.fromARGB(92, 138, 138, 138),
            //   ),
            //   label: Text('Upload',style: TextStyle(color: Colors.white),),
            //   icon: Icon(Icons.upload,color: Colors.white,),
              
            //   ),
            // )
          
          
          
          ],
        ),
      ),
    );
  }
}
