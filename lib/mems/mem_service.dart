import 'package:collection/collection.dart';
import 'package:mem/core/mem_detail.dart';
import 'package:mem/core/mem_notification.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/mems/mem_item_repository.dart';
import 'package:mem/repositories/mem.dart';
import 'package:mem/repositories/mem_entity.dart';
import 'package:mem/repositories/mem_item_entity.dart';
import 'package:mem/repositories/mem_notification_entity.dart';
import 'package:mem/repositories/mem_notification_repository.dart';
import 'package:mem/repositories/mem_repository.dart';

class MemService {
  final MemRepository _memRepository;
  final MemItemRepository _memItemRepository;
  final MemNotificationRepository _memNotificationRepository;

  Future<MemDetail> save(
    MemDetail memDetail, {
    bool undo = false,
  }) =>
      i(
        () async {
          final mem = memDetail.mem;

          final savedMem = (mem is SavedMemV1 && !undo
                  ? await _memRepository.replace(SavedMemEntity.fromV1(mem))
                  : await _memRepository.receive(MemEntity.fromV1(mem)))
              .toV1();

          final savedMemItems = await Future.wait(
            memDetail.memItems.map((e) => (e is SavedMemItemEntity && !undo
                ? _memItemRepository.replace(
                    e.copiedWith(memId: () => savedMem.id)
                        as SavedMemItemEntity,
                  )
                : _memItemRepository.receive(
                    e.copiedWith(memId: () => savedMem.id),
                  ))),
          );

          final memNotifications = memDetail.notifications;
          final returnMemNotifications =
              List<SavedMemNotificationEntity?>.empty(growable: true);
          if (memNotifications == null) {
            await _memNotificationRepository.waste(memId: savedMem.id);
          } else {
            returnMemNotifications.addAll(await Future.wait(memNotifications
                .where((e) => !e.isRepeatByDayOfWeek())
                .map((e) {
              if (e.isEnabled()) {
                return (e is SavedMemNotificationEntity && !undo
                    ? _memNotificationRepository.replace((e).copiedWith(
                        memId: () => savedMem.id,
                      ))
                    : _memNotificationRepository.receive(
                        (e as MemNotificationEntity).copiedWith(
                          memId: () => savedMem.id,
                        ),
                      ));
              } else {
                return _memNotificationRepository
                    .waste(
                      memId: savedMem.id,
                      type: e.type,
                    )
                    .then((v) => null);
              }
            })));

            await _memNotificationRepository.waste(
              memId: savedMem.id,
              type: MemNotificationType.repeatByDayOfWeek,
            );
            for (var entry in memNotifications
                .where((e) => e.isRepeatByDayOfWeek())
                .groupListsBy((e) => e.time)
                .entries) {
              returnMemNotifications.add(
                await _memNotificationRepository.receive(
                  (entry.value.first as MemNotificationEntity).copiedWith(
                    memId: () => savedMem.id,
                  ),
                ),
              );
            }
          }

          return MemDetail(
            savedMem,
            savedMemItems,
            returnMemNotifications
                .whereType<SavedMemNotificationEntity>()
                .toList(),
          );
        },
        {
          'memDetail': memDetail,
          'undo': undo,
        },
      );

  Future<MemDetail> doneByMemId(int memId) => i(
        () async {
          final done = (await _memRepository
                  .ship(id: memId)
                  .then((v) => v.single.toV1()))
              .copiedWith(doneAt: () => DateTime.now());
          return save(MemDetail(done, []));
        },
        {'memId': memId},
      );

  Future<MemDetail> undoneByMemId(int memId) => i(
        () async {
          final undone = (await _memRepository
                  .ship(id: memId)
                  .then((v) => v.single.toV1()))
              .copiedWith(doneAt: () => null);
          return save(MemDetail(undone, []));
        },
        {'memId': memId},
      );

  Future<MemDetail> archive(SavedMemV1 mem) => i(
        () async {
          final archivedMem = await _memRepository
              .archive(SavedMemEntity.fromV1(mem))
              .then((v) => v.toV1());
          final archivedMemItems =
              await _memItemRepository.archiveBy(memId: archivedMem.id);
          final archivedMemNotifications =
              await _memNotificationRepository.archiveBy(memId: archivedMem.id);

          return MemDetail(
            archivedMem,
            archivedMemItems.toList(),
            archivedMemNotifications.toList(),
          );
        },
        {
          "mem": mem,
        },
      );

  Future<MemDetail> unarchive(SavedMemV1 mem) => i(
        () async {
          final unarchivedMem = await _memRepository
              .unarchive(SavedMemEntity.fromV1(mem))
              .then((value) => value.toV1());
          final unarchivedMemItems =
              await _memItemRepository.unarchiveBy(memId: unarchivedMem.id);
          final unarchivedMemNotifications = await _memNotificationRepository
              .unarchiveBy(memId: unarchivedMem.id);

          return MemDetail(
            unarchivedMem,
            unarchivedMemItems.toList(growable: false),
            unarchivedMemNotifications.toList(growable: false),
          );
        },
        mem,
      );

  Future<bool> remove(int memId) => v(
        () async {
          // TODO https://github.com/zin-/mem/issues/284
          await _memNotificationRepository.waste(memId: memId);
          await _memItemRepository.waste(memId: memId);
          await _memRepository.waste(id: memId);

          return true;
        },
        {'memId': memId},
      );

  MemService._(
    this._memRepository,
    this._memItemRepository,
    this._memNotificationRepository,
  );

  static MemService? _instance;

  factory MemService() => i(
        () => _instance ??= MemService._(
          MemRepository(),
          MemItemRepository(),
          MemNotificationRepository(),
        ),
      );
}
