import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/mem_detail/mem_detail_states.dart';

class MemDetailPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final int? _memId;

  MemDetailPage(this._memId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer(
        builder: (context, ref, child) {
          ref.read(fetchMemById(_memId));
          final mem = ref.watch(memProvider(_memId));

          return Scaffold(
            appBar: AppBar(
              title: const Text('Detail'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: mem['name'],
                      validator: (value) {
                        if (value?.isEmpty ?? false) {
                          return 'Name is required.';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        ref
                            .read(memProvider(_memId).notifier)
                            .updatedBy(mem..['name'] = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.save_alt),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();

                  await ref.read(save(mem));
                }
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      );
}
