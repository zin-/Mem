import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/dimens.dart';
import 'package:mem/view/mem_detail_model.dart';
import 'package:mem/view/body.dart';

class MemDetail extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  final int _memId;

  MemDetail(this._memId);

  @override
  Widget build(BuildContext context, watch) {
    context.read(memDetailModelProvider) ??
        context
            .read(memDetailModelProvider.notifier)
            .fetch(_memId);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Center(
            child: MemDetailBody(
              _formKey,
              watch(memDetailModelProvider),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_alt),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            context
                .read(memDetailModelProvider.notifier)
                .save();
          }
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}
