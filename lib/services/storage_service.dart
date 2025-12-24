import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/energy_entry.dart';

class StorageService {
  static const String _entriesKey = 'energy_entries';

  Future<List<EnergyEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_entriesKey);

    if (entriesJson == null) return [];

    final List<dynamic> decoded = json.decode(entriesJson);
    return decoded.map((json) => EnergyEntry.fromJson(json)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveEntry(EnergyEntry entry) async {
    final entries = await getEntries();
    entries.add(entry);
    await _saveEntries(entries);
  }

  Future<void> deleteEntry(String id) async {
    final entries = await getEntries();
    entries.removeWhere((entry) => entry.id == id);
    await _saveEntries(entries);
  }

  Future<void> _saveEntries(List<EnergyEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = json.encode(
      entries.map((entry) => entry.toJson()).toList(),
    );
    await prefs.setString(_entriesKey, entriesJson);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_entriesKey);
  }
}
