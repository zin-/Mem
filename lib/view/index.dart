import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/dimens.dart';
import 'package:mem/view/mem_detail_model.dart';
import 'package:mem/view/body.dart';

class MemDetail extends ConsumerWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final int _memId;

  MemDetail(this._memId);

  @override
  Widget build(BuildContext context, watch) {
    final memDetailModel = watch(memDetailModelProvider);
    if (memDetailModel == null) {
      context
          .read(memDetailModelProvider.notifier)
          .fetch(_memId);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Center(
            child: MemDetailBody(
              _formKey,
              memDetailModel,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('save_fab'),
        child: Icon(Icons.save_alt),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            final savedMem = await context
                .read(memDetailModelProvider.notifier)
                .save();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Saved ${savedMem.name}"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
    );
  }
}
