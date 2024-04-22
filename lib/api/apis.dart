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

  Future<void> sendAudioFile(String filePath) async {
    try {
      print('api call');
      Uri apiUrl = Uri.parse('https://17ad-117-196-59-167.ngrok-free.app/predict'); // Replace with your actual API endpoint
      var request = http.MultipartRequest('POST', apiUrl);

      // Attach the audio file to the request
      request.files.add(await http.MultipartFile.fromPath('file',filePath));

      var response = await request.send();

      print('ggggggggggggggggggggggggggggggggggg');



      print(response.statusCode);

      if (response.statusCode == 200) {
        print('Audio file successfully uploaded!');
        // Handle the API response as needed
      } else {
        print('Failed to upload audio file. Status code: ${response.statusCode}');
        // Handle the error
      }
    } catch (e) {
      print('Error uploading audio file: $e');
      // Handle the error
    }
  }
}
