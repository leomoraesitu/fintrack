import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'transaction_local_data_source.dart';

class SharedPrefsTransactionLocalDataSource
    implements TransactionLocalDataSource {
  const SharedPrefsTransactionLocalDataSource(this._sharedPreferences);

  static const _storageKey = 'transactions';

  final SharedPreferences _sharedPreferences;

  @override
  Future<List<Map<String, dynamic>>> loadTransactions() async {
    final raw = _sharedPreferences.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveTransactions(List<Map<String, dynamic>> transactions) async {
    final encoded = jsonEncode(transactions);
    await _sharedPreferences.setString(_storageKey, encoded);
  }
}
