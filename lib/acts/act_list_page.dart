import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/acts/add_act_fab.dart';
import 'package:mem/core/mem.dart';
import 'package:mem/logger/log_service_v2.dart';

import 'act_list_view.dart';

class ActListPage extends ConsumerWidget {
  final MemId _memId;

  const ActListPage(this._memId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => i(
        () => Scaffold(
          body: ActListView(_memId),
          floatingActionButton: ActFab(_memId),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
}
