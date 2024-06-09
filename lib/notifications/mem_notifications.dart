import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mem/core/act.dart';
import 'package:mem/core/mem_notification.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/repositories/mem.dart';
import 'package:mem/repositories/mem_notification.dart';

import 'client.dart';
import 'notification/type.dart';
import 'notification_ids.dart';
import 'schedule.dart';

const memIdKey = 'memId';

class MemNotifications {
  static Iterable<Schedule> scheduleOf(
    SavedMem savedMem,
    TimeOfDay startOfDay,
    Iterable<SavedMemNotification> memNotifications,
    Future<void> Function(int, Map<String, dynamic>) callback,
  ) =>
      v(
        () => [
          ..._memPeriodSchedules(
            savedMem,
            startOfDay,
            callback,
          ),
          _memPeriodicSchedule(
            savedMem.id,
            memNotifications
                .whereType<SavedMemNotification>()
                .singleWhereOrNull(
                  (element) => element.isEnabled() && element.isRepeated(),
                ),
            callback,
          ),
        ],
        {
          "savedMem": savedMem,
          "startOfDay": startOfDay,
          "memNotifications": memNotifications,
        },
      );

  static Iterable<Schedule> _memPeriodSchedules(
    SavedMem savedMem,
    TimeOfDay startOfDay,
    Future<void> Function(int, Map<String, dynamic>) callback,
  ) =>
      v(
        () {
          final periodStart = savedMem.period?.start;
          final Schedule periodStartSchedule = periodStart == null
              ? CancelSchedule(memStartNotificationId(savedMem.id))
              : TimedSchedule(
                  memStartNotificationId(savedMem.id),
                  periodStart.isAllDay
                      ? DateTime(
                          periodStart.year,
                          periodStart.month,
                          periodStart.day,
                          startOfDay.hour,
                          startOfDay.minute,
                        )
                      : periodStart,
                  callback,
                  {
                    memIdKey: savedMem.id,
                    notificationTypeKey: NotificationType.startMem.name,
                  },
                );

          final periodEnd = savedMem.period?.end;
          final Schedule periodEndSchedule = periodEnd == null
              ? CancelSchedule(memEndNotificationId(savedMem.id))
              : () {
                  final endOfDay = startOfDay.subtractMinutes(1);
                  return TimedSchedule(
                    memEndNotificationId(savedMem.id),
                    periodEnd.isAllDay
                        ? DateTime(
                            periodEnd.year,
                            periodEnd.month,
                            // FIXME とりあえずここで実装するが、DateAndTimeの仕様として取り込むべきかも
                            //  endOfDayがstartOfDayより大きければ問題はない
                            //  小さい場合、それは1日回っているので、登録する日も追加する必要がある
                            startOfDay.compareTo(endOfDay) > 0
                                ? periodEnd.day + 1
                                : periodEnd.day,
                            endOfDay.hour,
                            endOfDay.minute,
                          )
                        : periodEnd,
                    callback,
                    {
                      memIdKey: savedMem.id,
                      notificationTypeKey: NotificationType.endMem.name,
                    },
                  );
                }();

          return [
            periodStartSchedule,
            periodEndSchedule,
          ];
        },
        {
          "savedMem": savedMem,
          "startOfDay": startOfDay,
        },
      );

  static Schedule _memPeriodicSchedule(
    int memId,
    SavedMemNotification? savedRepeatedMemNotifications,
    Future<void> Function(int, Map<String, dynamic>) callback,
  ) =>
      v(
        () => savedRepeatedMemNotifications == null
            ? CancelSchedule(memRepeatedNotificationId(memId))
            : PeriodicSchedule(
                memRepeatedNotificationId(memId),
                DateTime.now()
                    .copyWith(
                      hour: 0,
                      minute: 0,
                      second: 0,
                      millisecond: 0,
                      microsecond: 0,
                    )
                    .add(Duration(
                        seconds: savedRepeatedMemNotifications
                            // FIXME 永続化されている時点でtimeは必ずあるので型で表現する
                            .time!)),
                const Duration(days: 1),
                callback,
                {
                  memIdKey: memId,
                  notificationTypeKey: NotificationType.repeat.name,
                },
              ),
        {
          "memId": memId,
          "savedMemNotifications": savedRepeatedMemNotifications,
        },
      );

  static DateTime? nexRepeatNotifyAt(
    Iterable<MemNotification> memNotifications,
    TimeOfDay startOfDay,
    Act? latestAct,
    DateTime now,
  ) =>
      v(
        () {
          DateTime? notifyAt;

          if (latestAct?.isActive == true) {
            return null;
          } else if (memNotifications
              .whereType<SavedMemNotification>()
              .isNotEmpty) {
            final repeatAt = memNotifications
                .singleWhereOrNull((e) => e.isRepeated() && e.isEnabled())
                ?.time;
            final timeOfDay = repeatAt == null
                ? startOfDay
                : TimeOfDay(
                    hour: (repeatAt / 60 / 60).floor(),
                    minute: (repeatAt / 60).floor());

            if (latestAct == null) {
              notifyAt = now.copyWith(
                  hour: timeOfDay.hour,
                  minute: timeOfDay.minute,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0);
            } else {
              notifyAt = latestAct.period.end!
                  .copyWith(
                      hour: timeOfDay.hour,
                      minute: timeOfDay.minute,
                      second: 0,
                      millisecond: 0,
                      microsecond: 0)
                  .add(Duration(
                    days: memNotifications
                            .singleWhereOrNull((e) => e.isRepeatByNDay())
                            ?.time ??
                        1,
                  ));
            }

            final daysOfWeek = memNotifications
                .where((e) => e.isRepeatByDayOfWeek() && e.isEnabled());

            while (daysOfWeek.isNotEmpty &&
                !daysOfWeek.map((e) => e.time).contains(notifyAt?.weekday)) {
              notifyAt = notifyAt?.add(const Duration(days: 1));
            }
          }

          return notifyAt;
        },
        {
          'memNotifications': memNotifications,
          'startOfDay': startOfDay,
          'latestAct': latestAct,
          'now': now,
        },
      );
}

class AllMemNotificationsId {
  static List<int> of(int memId) => [
        memStartNotificationId(memId),
        memEndNotificationId(memId),
        memRepeatedNotificationId(memId),
        activeActNotificationId(memId),
        pausedActNotificationId(memId),
        afterActStartedNotificationId(memId),
      ];
}

// FIXME どこからでも参照できるとこに定義する
//  どこからでもか？
//    フロントでしか使えない
extension on TimeOfDay {
  TimeOfDay subtractMinutes(int minutes) {
    int subtracted = (_totalMinutes - minutes + 24 * 60) % (24 * 60);
    return TimeOfDay(hour: subtracted ~/ 60, minute: subtracted % 60);
  }

  int compareTo(TimeOfDay other) =>
      _totalMinutes.compareTo(other._totalMinutes);

  int get _totalMinutes => hour * 60 + minute;
}
