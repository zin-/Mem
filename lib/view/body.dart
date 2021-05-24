import 'package:flutter/material.dart';
import 'package:mem/dimens.dart';
import 'package:mem/view/loading.dart';

import '../domain/mem.dart';

class MemDetailBody extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final Mem _mem;
  final _remarksFocusNode = FocusNode();

  MemDetailBody(this._formKey, this._mem);

  @override
  Widget build(BuildContext context) {
    if (_mem == null) {
      return Loading();
    } else {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              key: Key('mem_name'),
              initialValue: _mem?.name ?? "",
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name is required.";
                }
                return null;
              },
              onSaved: (newValue) {
                _mem.name = newValue;
              },
            ),
            TextFormField(
              key: Key('mem_remarks'),
              initialValue: _mem?.remarks ?? "",
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
                _mem.remarks = newValue;
              },
            ),
          ],
        ),
      );
    }
  }
}
