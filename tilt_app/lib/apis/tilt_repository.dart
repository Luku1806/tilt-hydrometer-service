import 'dart:convert';

import 'package:binary_music_tools/models/tilt.dart';
import 'package:http/http.dart' as http;

class TiltRepository {
  Future<List<Tilt>> findAll() async {
    final response = await http.get(Uri.parse(""));

    final decodedJson = jsonDecode(response.body);
    final tilts = decodedJson["tilts"] as Map<String, dynamic>;
    final lastUpdated = decodedJson["lastUpdated"];

    return tilts.entries
        .map<Tilt>((tilt) => Tilt.fromDto(tilt.key, lastUpdated, tilt.value))
        .toList();
  }
}
