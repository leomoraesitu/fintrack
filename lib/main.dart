import 'package:fintrack/features/transactions/data/datasources/shared_prefs_transaction_local_data_source.dart';
import 'package:fintrack/features/transactions/data/models/transaction_storage_mapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintrack/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final localDataSource = SharedPrefsTransactionLocalDataSource(
    sharedPreferences,
  );

  final storedTransactions = await localDataSource.loadTransactions();

  final initialTransactions = storedTransactions
      .map(TransactionStorageMapper.fromMap)
      .toList();

  runApp(
    FinTrackApp(
      sharedPreferences: sharedPreferences,
      initialTransactions: initialTransactions,
    ),
  );
}
