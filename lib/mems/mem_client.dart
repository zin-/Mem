import 'package:mem/core/mem.dart';
import 'package:mem/core/mem_detail.dart';
import 'package:mem/core/mem_item.dart';
import 'package:mem/core/mem_notification.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/notifications/notification_client.dart';
import 'package:mem/repositories/mem.dart';
import 'package:mem/repositories/mem_notification.dart';

import 'mem_service.dart';

class MemClient {
  final MemService _memService;
  final NotificationClient _notificationClient;

  Future<MemDetail> save(
    MemV1 mem,
    List<MemItem> memItemList,
    List<MemNotification> memNotificationList,
  ) =>
      v(
        () async {
          final saved = await _memService.save(
            MemDetail(
              mem,
              memItemList,
              memNotificationList,
            ),
          );

          _notificationClient.registerMemNotifications(
            (saved.mem as SavedMemV1).id,
            savedMem: saved.mem as SavedMemV1,
            savedMemNotifications:
                saved.notifications?.whereType<SavedMemNotification>(),
          );

          return saved;
        },
        {
          "mem": mem,
          "memItemList": memItemList,
          "memNotificationList": memNotificationList,
        },
      );

  Future<MemDetail> archive(MemV1 mem) => v(
        () async {
          // FIXME MemServiceの責務
          if (mem is SavedMemV1) {
            final archived = await _memService.archive(mem);

            final archivedMem = archived.mem;
            // FIXME archive後のMemDetailなので、必ずSavedMemのはず
            if (archivedMem is SavedMemV1) {
              _notificationClient.cancelMemNotifications(archivedMem.id);
            }

            return archived;
            // } else {
            //   // FIXME Memしかないので、子の状態が分からない
            //   _memService.save();
          }

          throw Error(); // coverage:ignore-line
        },
        {
          "mem": mem,
        },
      );

  Future<MemDetail> unarchive(MemV1 mem) => v(
        () async {
          // FIXME MemServiceの責務
          if (mem is SavedMemV1) {
            final unarchived = await _memService.unarchive(mem);

            _notificationClient.registerMemNotifications(
              (unarchived.mem as SavedMemV1).id,
              savedMem: unarchived.mem as SavedMemV1,
              savedMemNotifications:
                  unarchived.notifications?.whereType<SavedMemNotification>(),
            );

            return unarchived;
            // } else {
            //   // FIXME Memしかないので、子の状態が分からない
            //   _memService.save();
          }

          throw Error(); // coverage:ignore-line
        },
        {
          "mem": mem,
        },
      );

  Future<bool> remove(int memId) => v(
        () async {
          final removeSuccess = await _memService.remove(memId);

          if (removeSuccess) {
            _notificationClient.cancelMemNotifications(memId);
          }

          return removeSuccess;
        },
        {
          "memId": memId,
        },
      );

  MemClient._(
    this._memService,
    this._notificationClient,
  );

  static MemClient? _instance;

  factory MemClient() => v(
        () => _instance ??= MemClient._(
          MemService(),
          NotificationClient(),
        ),
      );
}
