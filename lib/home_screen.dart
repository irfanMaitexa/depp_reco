import 'package:depp_reco/api/apis.dart';
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



    final _apiServices =  ApiServices();

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

          await _apiServices.sendAudioFile(selectedFilePath!);

    

          valueNotifier.value = 90;



          setState(() {
            loading =  false;
          });
        

        if (context.mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioUploadScreen(
                  gender: 'male',
                  
                ),
              ));
        }
      } else {

      }
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
    return  Scaffold(
    backgroundColor: Color(0xff032129),
     body:loading ?  Center(child: CircularProgressIndicator(color: Colors.white,),) : Column(
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
        

        Expanded(
          flex: 2,
          child: Image.asset('assets/s.png',)
        ),
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [

          //   const SizedBox(height: 20,)

          //  , Opacity(
          //     opacity: 1,
          //     child: Container(
               
          //       margin: const EdgeInsets.symmetric(horizontal: 20),
          //       padding: const EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         color: const Color.fromARGB(92, 138, 138, 138),
                  
          //         borderRadius: BorderRadius.circular(25)
                  
                  
                  
          //       ),
          //       child: const ListTile(
                  
          //         title: Text('Record',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),),
          //         subtitle: Text('Record your audio',style: TextStyle(color: Colors.white),),
          //         trailing: Icon(Icons.record_voice_over,color: Colors.white,),
          //       ),
          //     ),
          //   )
         
         const SizedBox(height: 30,)
          ,
           Opacity(
              opacity: 1,
              child: Container(
               
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(92, 138, 138, 138),
                  
                  borderRadius: BorderRadius.circular(25)
                  
                  
                  
                ),
                child:  ListTile(
                  onTap: () {

                    pickAudioFile();

                    
                  },
                  
                  title: Text('Upload',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),),
                  subtitle: Text('upload your audiofile',style: TextStyle(color: Colors.white),),
                  trailing: Icon(Icons.file_upload_outlined,color: Colors.white,),
                ),
              ),
            ),
            const SizedBox(height: 30,)
          
          
          ],
        ))
      ],
     ),
    );
  }
}