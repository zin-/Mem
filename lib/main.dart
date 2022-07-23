import 'package:flutter/material.dart';

import 'package:mem/app.dart';
import 'package:mem/database/database.dart';
import 'package:mem/database/database_factory.dart';

void main() async {
  await _openDatabase();

  runApp(const MemApplication());
}

Future<Database> _openDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await DatabaseFactory.open(
    'mem.db',
    1,
    [],
  );

  return database;
}
