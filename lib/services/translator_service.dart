import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslatorService {
  static const _apiKey = '';
  final _url = Uri.parse('https://translation.googleapis.com/language/translate/v2');

  Future<String?> traduzirParaIngles(String textoPt) async {
    final response = await http.post(
      _url.replace(queryParameters: {
        'key': _apiKey,
      }),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': textoPt,
        'source': 'pt',
        'target': 'en',
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      print('Erro API: ${response.body}');
      return null;
    }
  }
}
