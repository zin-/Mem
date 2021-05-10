import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mem/dimens.dart';

class MemDetailBody extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final _remarksFocusNode = FocusNode();

  MemDetailBody(this._formKey);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Name",
            ),
            style: TextStyle(
              fontSize: primaryFontSize,
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context)
                  .requestFocus(_remarksFocusNode);
            },
            onSaved: (newValue) {
              log(newValue);
              // TODO update state via riverpod
            },
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
            focusNode: _remarksFocusNode,
            onSaved: (newValue) {
              log(newValue);
              // TODO update state via riverpod
            },
          ),
        ],
      ),
    );
  }
}
