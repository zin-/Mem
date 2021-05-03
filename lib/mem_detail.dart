import 'package:flutter/material.dart';

class MemDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                TextFormField(),
                TextFormField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
