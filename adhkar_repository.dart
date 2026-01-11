import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../domain/adhkar_item.dart';

class AdhkarRepository {
  final Box<AdhkarItem> _box;

  AdhkarRepository(this._box);

  Future<void> init() async {
    if (_box.isEmpty) {
      final String response = await rootBundle.loadString('assets/data/adhkar.json');
      final data = await json.decode(response) as List;
      final items = data.map((json) => AdhkarItem.fromJson(json)).toList();
      for (var item in items) {
        await _box.add(item);
      }
    }
  }

  List<AdhkarItem> getAdhkarByType(String type) {
    return _box.values.where((item) => item.type == type).toList();
  }
}
