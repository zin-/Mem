import 'package:flutter/material.dart';
import 'package:mem/dimens.dart';

class MemDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                    style: TextStyle(
                      fontSize: primaryFontSize,
                    ),
                  ),
                  TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.subject),
                      labelText: "Remarks",
                    ),
                    style: TextStyle(
                      fontSize: secondaryFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_alt),
        onPressed: () {
          print('test');
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}
