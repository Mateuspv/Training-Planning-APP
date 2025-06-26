import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionixService {
  static const _appId = '';
  static const _appKey = '';
  static const _url = 'https://trackapi.nutritionix.com/v2/natural/nutrients';

  Future<Map<String, dynamic>?> buscarAlimento(String alimento) async {
    final uri = Uri.parse(_url);

    final response = await http.post(
      uri,
      headers: {
        'x-app-id': _appId,
        'x-app-key': _appKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': alimento}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['foods'] != null && data['foods'].isNotEmpty) {
        return data['foods'][0];
      }
    }

    return null;
  }
}
