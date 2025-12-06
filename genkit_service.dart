import 'dart:convert';
import 'package:http/http.dart' as http;

class GenkitService {
  static const String _baseUrl = 'https://firebase.googleapis.com/v1beta';
  static const String _apiKey = 'YOUR_FIREBASE_API_KEY'; // Replace with actual key

  Future<String> generateCropRecommendation(String location, String soilType, String season) async {
    final prompt = '''
    Based on the following conditions:
    - Location: $location
    - Soil Type: $soilType  
    - Season: $season
    
    Recommend the best crops to plant and provide farming tips.
    ''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-pro:generateContent?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
      return 'Unable to generate recommendation';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<Map<String, dynamic>> analyzeCropImage(String base64Image) async {
    final prompt = '''
    Analyze this crop image and provide:
    1. Crop type identification
    2. Health assessment
    3. Disease detection (if any)
    4. Growth stage
    5. Recommendations
    ''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-pro-vision:generateContent?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [
              {'text': prompt},
              {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image}}
            ]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'analysis': data['candidates'][0]['content']['parts'][0]['text'],
          'confidence': 0.85,
        };
      }
      return {'error': 'Analysis failed'};
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }
}