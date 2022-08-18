import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mem/l10n.dart';
import 'package:mem/logger.dart';
import 'package:mem/mem.dart';
import 'package:mem/repositories/mem_repository.dart';
import 'package:mem/views/dimens.dart';
import 'package:mem/views/atoms/async_value_view.dart';
import 'package:mem/views/constants.dart';
import 'package:mem/views/mem_detail/mem_detail_states.dart';
import 'package:mem/views/mem_name.dart';

class MemDetailPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final int? _memId;

  MemDetailPage(this._memId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => t(
        {},
        () => Consumer(
          builder: (context, ref, child) => v(
            {},
            () {
              final mem = ref.watch(memProvider(_memId));
              final memMap = ref.watch(memMapProvider(_memId));

              return WillPopScope(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(L10n().memDetailPageTitle()),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.archive),
                        color: Colors.white,
                        onPressed: () {
                          if (Mem.isSavedMap(memMap)) {
                            ref.read(archiveMem(memMap)).then((archived) =>
                                Navigator.of(context).pop(archived));
                          } else {
                            Navigator.of(context).pop(null);
                          }
                        },
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                const Icon(Icons.delete, color: Colors.black),
                                Text(L10n().removeAction())
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(L10n().removeConfirmation()),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (Mem.isSavedMap(memMap)) {
                                              MemRepository()
                                                  .discardWhereIdIs(
                                                      memMap['id'])
                                                  .then((value) =>
                                                      Navigator.of(context)
                                                        ..pop()
                                                        ..pop(null));
                                            } else {
                                              Navigator.of(context)
                                                ..pop()
                                                ..pop(null);
                                            }
                                          },
                                          child: Text(L10n().okAction()),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary: Colors.black,
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(L10n().cancelAction()),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: pagePadding,
                    child: Form(
                      key: _formKey,
                      child: memMap.length < 2
                          ? AsyncValueView(
                              ref.watch(fetchMemById(_memId)),
                              (Map<String, dynamic> memDataMap) =>
                                  _buildBody(ref, memMap),
                            )
                          : _buildBody(ref, memMap),
                    ),
                  ),
                  floatingActionButton: Consumer(
                    builder: (context, ref, child) {
                      return FloatingActionButton(
                        child: const Icon(Icons.save_alt),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await ref.read(saveMem(memMap)).then((saveSuccess) {
                              if (saveSuccess) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(L10n()
                                      .saveMemSuccessMessage(memMap['name'])),
                                  duration: defaultDismissDuration,
                                  dismissDirection: DismissDirection.horizontal,
                                ));
                              }
                            });
                          }
                        },
                      );
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                ),
                onWillPop: () async {
                  Navigator.of(context).pop(mem);
                  return true;
                },
              );
            },
          ),
        ),
      );

  Widget _buildBody(WidgetRef ref, Map<String, dynamic> memMap) {
    return Column(
      children: [
        MemNameTextFormField(
          memMap['name'] ?? '',
          memMap['id'],
          (value) =>
              (value?.isEmpty ?? false) ? L10n().memNameIsRequiredWarn() : null,
          (value) => ref
              .read(memMapProvider(_memId).notifier)
              .updatedBy(Map.of(memMap..['name'] = value)),
        ),
      ],
    );
  }
}
