import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/component/view/mem_list/states.dart';
import 'package:mem/logger/i/api.dart';
import 'package:mem/mems/detail/mem_detail_states.dart';
import 'package:mem/mems/mem_service.dart';

final doneMem = Provider.autoDispose.family<Future<MemDetail>, int>(
  (ref, memId) => v(
    {'memId': memId},
    () async {
      final doneMemDetail = await MemService().doneByMemId(memId);

      ref
          .read(memProvider(doneMemDetail.mem.id).notifier)
          .updatedBy(doneMemDetail.mem);
      ref
          .read(rawMemListProvider.notifier)
          .upsertAll([doneMemDetail.mem], (tmp, item) => tmp.id == item.id);

      return doneMemDetail;
    },
  ),
);
final undoneMem = Provider.autoDispose.family<Future<MemDetail>, int>(
  (ref, memId) => v(
    {'memId': memId},
    () async {
      final undoneMemDetail = await MemService().undoneByMemId(memId);

      ref
          .read(memProvider(undoneMemDetail.mem.id).notifier)
          .updatedBy(undoneMemDetail.mem);
      ref
          .read(rawMemListProvider.notifier)
          .upsertAll([undoneMemDetail.mem], (tmp, item) => tmp.id == item.id);

      return undoneMemDetail;
    },
  ),
);
