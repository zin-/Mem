import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/notifications/client.dart';
import 'package:mem/notifications/notification/type.dart';
import 'package:mem/repositories/mem.dart';

import 'notification_ids.dart';
import 'schedule.dart';

const memIdKey = 'memId';

class MemNotifications {
  static Iterable<Schedule> scheduleOf(
    SavedMem savedMem,
    TimeOfDay startOfDay,
    Function callback,
  ) =>
      v(
        () {
          final memPeriodSchedules = _memPeriodSchedules(
            savedMem,
            startOfDay,
            callback,
          );

          return [
            memPeriodSchedules,
          ].flattened;
        },
        {
          "savedMem": savedMem,
          "startOfDay": startOfDay,
        },
      );

  static Iterable<Schedule> _memPeriodSchedules(
    SavedMem savedMem,
    TimeOfDay startOfDay,
    Function callback,
  ) =>
      v(
        () {
          final periodStart = savedMem.period?.start;
          TimedSchedule? periodStartSchedule;
          if (periodStart == null) {
            // TODO 値の指定がない場合キャンセルする
            //  キャンセルの判断はここでやるべきか？
            //    ここでやる場合Scheduleを返却するので、CancelScheduleみたいなことになる
            //    CancelEntityをRepositoryに渡すのはどうなんだ？
            //  endの方も同様
          } else {
            periodStartSchedule = TimedSchedule(
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
          }

          final periodEnd = savedMem.period?.end;
          TimedSchedule? periodEndSchedule;
          if (periodEnd == null) {
            // TODO
          } else {
            final endOfDay = startOfDay.subtractMinutes(1);
            periodEndSchedule = TimedSchedule(
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
          }

          return [
            if (periodStartSchedule != null) periodStartSchedule,
            if (periodEndSchedule != null) periodEndSchedule,
          ];
        },
        {
          "savedMem": savedMem,
          "startOfDay": startOfDay,
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
