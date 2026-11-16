import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Loads and caches all 37 Nigerian states (including FCT) and their 774 LGAs.
class NigeriaLocationsService {
  static const _assetPath = 'assets/data/nigeria_states_lgas.json';
  static Map<String, List<String>>? _cache;

  static Future<Map<String, List<String>>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _cache = decoded.map(
      (k, v) => MapEntry(k, List<String>.from(v as List)),
    );
    return _cache!;
  }

  static Future<List<String>> getStates() async {
    final map = await loadAll();
    return map.keys.toList();
  }

  static Future<List<String>> getLgasForState(String state) async {
    final map = await loadAll();
    final key = map.keys.firstWhere(
      (k) => k.toLowerCase() == state.trim().toLowerCase(),
      orElse: () => '',
    );
    return key.isEmpty ? const [] : (map[key] ?? const []);
  }
}
