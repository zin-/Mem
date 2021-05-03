import 'package:flutter/material.dart';
import 'package:mem/mem_detail.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mem',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemDetail(),
    );
  }
}
