import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/logger/i/api.dart';
import 'package:mem/mems/mem_done_checkbox.dart';
import 'package:mem/mems/detail/states.dart';
import 'package:mem/mems/mem_name.dart';
import 'package:mem/mems/mem_period.dart';

import 'mem_items_view.dart';

class MemDetailBody extends StatelessWidget {
  final int? _memId;

  const MemDetailBody(this._memId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => v(
        {'_memId': _memId},
        () {
          return SingleChildScrollView(
            child: Consumer(
              builder: (context, ref, child) {
                final editingMem = ref.watch(editingMemProvider(_memId));

                return Column(
                  children: [
                    MemNameTextFormField(
                      editingMem.name,
                      editingMem.id,
                      (value) => ref
                          .read(editingMemProvider(_memId).notifier)
                          .updatedBy(
                            editingMem.copied()..name = value,
                          ),
                    ),
                    MemDoneCheckbox(
                      editingMem,
                      (value) => ref
                          .read(editingMemProvider(_memId).notifier)
                          .updatedBy(
                            editingMem.copied()
                              ..doneAt = value == true ? DateTime.now() : null,
                          ),
                    ),
                    MemPeriodTextFormFields(_memId),
                    MemItemsView(_memId),
                  ],
                );
              },
            ),
          );
        },
      );
}