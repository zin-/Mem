import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/logger.dart';
import 'package:mem/views/mems/mem_detail/mem_items_view.dart';
import 'package:mem/views/mems/mem_notify_at.dart';
import 'package:mem/views/mems/mem_done_checkbox.dart';
import 'package:mem/views/mems/mem_name.dart';
import 'package:mem/views/mems/mem_detail/mem_detail_states.dart';

class MemDetailBody extends StatelessWidget {
  final int? _memId;

  const MemDetailBody(this._memId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => t(
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
                      editingMem.id,
                      editingMem.doneAt != null,
                      (value) => ref
                          .read(editingMemProvider(_memId).notifier)
                          .updatedBy(
                            editingMem.copied()
                              ..doneAt = value == true ? DateTime.now() : null,
                          ),
                    ),
                    MemNotifyAtTextFormField(
                      editingMem,
                      (dateTime, timeOfDay) => ref
                          .read(editingMemProvider(_memId).notifier)
                          .updatedBy(
                            editingMem.copied()
                              ..notifyOn = dateTime
                              ..notifyAt = timeOfDay,
                          ),
                    ),
                    MemItemsView(_memId),
                  ],
                );
              },
            ),
          );
        },
      );
}
