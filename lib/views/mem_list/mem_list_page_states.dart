import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mem/logger.dart';
import 'package:mem/repositories/mem_repository.dart';
import 'package:mem/views/mem_detail/mem_detail_states.dart';
import 'package:mem/views/atoms/state_notifier.dart';

final showNotArchivedProvider =
    StateNotifierProvider<ValueStateNotifier<bool>, bool>(
  (ref) => v(
    {},
    () => ValueStateNotifier(true),
  ),
);
final showArchivedProvider =
    StateNotifierProvider<ValueStateNotifier<bool>, bool>(
  (ref) => v(
    {},
    () => ValueStateNotifier(false),
  ),
);

final fetchMemList = FutureProvider<List<MemEntity>>(
  (ref) => v(
    {},
    () async {
      final showNotArchived = ref.watch(showNotArchivedProvider);
      final showArchived = ref.watch(showArchivedProvider);

      final mems = await MemRepository().ship(
        archived: showNotArchived == showArchived ? null : showArchived,
      );

      final memListNotifier = ref.read(memListProvider.notifier);
      for (var mem in mems) {
        ref.read(memProvider(mem.id).notifier).updatedBy(mem);
        memListNotifier.upsert(mem, (item) => item.id == mem.id);
      }

      return mems;
    },
  ),
);

final memListProvider =
    StateNotifierProvider<ListValueStateNotifier<MemEntity>, List<MemEntity>?>(
  (ref) => v(
    {},
    // TODO ListValueStateは要素が変更されたらリスナーに通知して欲しい
    // これは、Viewがそれぞれに要素を見るという話ではなく、ListValueStateが持っていて欲しい
    () {
      final listValueState = ListValueStateNotifier<MemEntity>(null);

      return listValueState;
    },
  ),
);

final filteredMemListProvider =
    StateNotifierProvider<ValueStateNotifier<List<MemEntity>>, List<MemEntity>>(
  (ref) => v(
    {},
    () {
      final memList = ref.watch(memListProvider) ?? [];

      final showNotArchived = ref.watch(showNotArchivedProvider);
      final showArchived = ref.watch(showArchivedProvider);

      final filteredMemList = memList.where((item) {
        if (showNotArchived == showArchived) {
          return true;
        }
        if (item.archivedAt == null) {
          return showNotArchived;
        } else {
          return showArchived;
        }
      }).toList();

      return ValueStateNotifier(filteredMemList);
    },
  ),
);
final sortedMemList =
    StateNotifierProvider<ValueStateNotifier<List<MemEntity>>, List<MemEntity>>(
  (ref) => v(
    {},
    () {
      final filteredMemList = ref.watch(filteredMemListProvider);

      final sortedMemList = filteredMemList.sorted((item1, item2) {
        if (item1.archivedAt != item2.archivedAt) {
          if (item1.archivedAt == null) {
            return -1;
          }
          if (item2.archivedAt == null) {
            return 1;
          }
          return item1.archivedAt!.compareTo(item2.archivedAt!);
        }

        return item1.id.compareTo(item2.id);
      });

      return ValueStateNotifier(sortedMemList);
    },
  ),
);
