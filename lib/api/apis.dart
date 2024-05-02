import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<bool> getVoiceFakeOrNot() async {
    try {
      await Future.delayed(const Duration(seconds: 6));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>> sendAudioFile(String filePath) async {
    try {
      print('api call');
      Uri apiUrl = Uri.parse('https://3662-117-201-196-79.ngrok-free.app/predict'); // Replace with your actual API endpoint
      var request = http.MultipartRequest('POST', apiUrl);

      // Attach the audio file to the request
      request.files.add(await http.MultipartFile.fromPath('file',filePath));

      var response = await request.send();

      



      print(response.statusCode);

      if (response.statusCode == 200) {

        final responseData = await response.stream.bytesToString();
      final parsedData = json.decode(responseData);


      return parsedData;

       
      } else {

        throw 'Somthing went wrong';
        
      }
    } catch (e) {
      rethrow;
    }
  }
}
