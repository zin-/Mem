import 'package:flutter/material.dart';
import 'package:mem/dimens.dart';
import 'package:mem/view/body.dart';

class MemDetail extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Center(
            child: MemDetailBody(_formKey),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_alt),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            // TODO get state via riverpod and save
          }
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}
