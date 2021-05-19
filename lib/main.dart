import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mem/app.dart';
import 'package:mem/model/database.dart';

void main() async {
  log('main');
  WidgetsFlutterBinding.ensureInitialized();
  final bool dbIsInitialized =
      await MemDbModel().initializeDB();
  if (dbIsInitialized == true) {
    runApp(
      App(),
    );
  }
}
