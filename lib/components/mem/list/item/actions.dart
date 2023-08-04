import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/core/mem_detail.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/mems/mem_service.dart';
import 'package:mem/mems/states.dart';

final doneMem = Provider.autoDispose.family<Future<MemDetail>, int>(
  (ref, memId) => v(
    () async {
      final doneMemDetail = await MemService().doneByMemId(memId);

      ref
          .read(memsProvider.notifier)
          .upsertAll([doneMemDetail.mem], (tmp, item) => tmp.id == item.id);

      return doneMemDetail;
    },
    {'memId': memId},
  ),
);
final undoneMem = Provider.autoDispose.family<Future<MemDetail>, int>(
  (ref, memId) => v(
    () async {
      final undoneMemDetail = await MemService().undoneByMemId(memId);

      ref
          .read(memsProvider.notifier)
          .upsertAll([undoneMemDetail.mem], (tmp, item) => tmp.id == item.id);

      return undoneMemDetail;
    },
    {'memId': memId},
  ),
);
