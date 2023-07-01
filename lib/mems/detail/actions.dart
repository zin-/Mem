import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/component/view/mem_list/states.dart';
import 'package:mem/core/mem_detail.dart';
import 'package:mem/core/mem_item.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/mems/detail/states.dart';
import 'package:mem/mems/mem_repeated_notification_repository.dart';
import 'package:mem/mems/mem_service.dart';
import 'package:mem/mems/states.dart';

final loadMemItems = Provider.autoDispose.family<Future<List<MemItem>>, int?>(
  (ref, memId) => v(
    () async {
      List<MemItem> memItems = [];

      if (memId != null) {
        memItems = await MemService().fetchMemItemsByMemId(memId);
      }

      if (memItems.isEmpty) {
        memItems = [
          MemItem(memId: memId, type: MemItemType.memo, value: ''),
        ];
      }

      return memItems;
    },
    memId,
  ),
);
final loadMemRepeatedNotification =
    FutureProvider.autoDispose.family<void, int?>(
  (ref, memId) => v(
    () async {
      if (memId != null) {
        final memRepeatedNotifications =
            await MemRepeatedNotificationRepository().shipByMemId(memId);

        if (memRepeatedNotifications.length == 1) {
          ref
              .watch(memRepeatedNotificationProvider(memId).notifier)
              .updatedBy(memRepeatedNotifications.single);
        }
      }
    },
    memId,
  ),
);

final saveMem =
    Provider.autoDispose.family<Future<MemDetail>, int?>((ref, memId) => v(
          () async {
            final saved = await MemService().save(
              ref.watch(memDetailProvider(memId)),
            );

            ref.read(editingMemProvider(memId).notifier).updatedBy(saved.mem);
            ref
                .read(memItemsProvider(memId).notifier)
                .updatedBy(saved.memItems);
            ref
                .read(memRepeatedNotificationProvider(memId).notifier)
                .updatedBy(saved.repeatedNotification);

            if (memId == null) {
              ref
                  .read(editingMemProvider(saved.mem.id).notifier)
                  .updatedBy(saved.mem);
              ref
                  .read(memItemsProvider(saved.mem.id).notifier)
                  .updatedBy(saved.memItems);
              ref
                  .read(memRepeatedNotificationProvider(saved.mem.id).notifier)
                  .updatedBy(saved.repeatedNotification);
            }

            ref
                .read(rawMemListProvider.notifier)
                .upsertAll([saved.mem], (tmp, item) => tmp.id == item.id);

            return saved;
          },
          memId,
        ));

final archiveMem = Provider.family<Future<MemDetail?>, int?>(
  (ref, memId) => v(
    () async {
      final mem = ref.read(editingMemProvider(memId));

      final archived = await MemService().archive(mem);

      ref.read(editingMemProvider(memId).notifier).updatedBy(archived.mem);
      ref
          .read(rawMemListProvider.notifier)
          .upsertAll([archived.mem], (tmp, item) => tmp.id == item.id);

      return archived;
    },
    {'memId': memId},
  ),
);

final unarchiveMem = Provider.family<Future<MemDetail?>, int?>(
  (ref, memId) => v(
    () async {
      final mem = ref.read(editingMemProvider(memId));

      final unarchived = await MemService().unarchive(mem);

      ref.read(editingMemProvider(memId).notifier).updatedBy(unarchived.mem);
      ref
          .read(rawMemListProvider.notifier)
          .upsertAll([unarchived.mem], (tmp, item) => tmp.id == item.id);

      return unarchived;
    },
    {'memId': memId},
  ),
);

final removeMem = Provider.family<Future<bool>, int?>(
  (ref, memId) => v(
    () async {
      if (memId != null) {
        final removeSuccess = await MemService().remove(memId);

        ref.read(removedMemProvider(memId).notifier).updatedBy(
              ref
                  .read(memListProvider)
                  .firstWhere((element) => element.id == memId),
            );
        ref.read(removedMemItemsProvider(memId).notifier).updatedBy(
              ref.read(memItemsProvider(memId)),
            );

        ref
            .read(rawMemListProvider.notifier)
            .removeWhere((element) => element.id == memId);

        return removeSuccess;
      }

      return false;
    },
    memId,
  ),
);
