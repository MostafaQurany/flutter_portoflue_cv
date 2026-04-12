import 'dart:convert';

import 'package:flutter/services.dart';

class JsonAssetLoader {
  const JsonAssetLoader();

  Future<Map<String, dynamic>> loadMap(String assetPath) async {
    final rawJson = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(rawJson);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object.');
    }

    return decoded;
  }

  Future<List<dynamic>> loadList(String assetPath) async {
    final rawJson = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(rawJson);

    if (decoded is! List<dynamic>) {
      throw const FormatException('Expected a JSON array.');
    }

    return decoded;
  }
}
