import 'dart:convert';

import 'package:binary_music_tools/models/tilt.dart';
import 'package:http/http.dart' as http;

class TiltRepository {
  static const _baseUrl = "https://tilt-functions.azurewebsites.net";

  Future<String> _accessTokenForIdToken(String idToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/.auth/login/google'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id_token': idToken}),
    );

    return jsonDecode(response.body)["authenticationToken"];
  }

  Future<List<Tilt>> findByAdapterId({
    required String adapterId,
    required idToken,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/adapters/$adapterId'),
      headers: {"X-ZUMO-AUTH": await _accessTokenForIdToken(idToken)},
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Api returned error ${response.statusCode} with message ${response.body}",
      );
    }

    final decodedJson = jsonDecode(response.body);
    final tilts = decodedJson["tilts"] as Map<String, dynamic>;
    final lastUpdated = decodedJson["lastUpdated"];

    return tilts.entries
        .map<Tilt>((tilt) => Tilt.fromDto(tilt.key, lastUpdated, tilt.value))
        .toList();
  }
}
