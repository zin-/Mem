import 'package:mem/framework/repository/entity.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/notifications/client.dart';
import 'package:mem/notifications/mem_notifications.dart';
import 'package:mem/notifications/notification/type.dart';

abstract class Schedule extends Entity {
  final int id;

  Schedule(this.id);

  factory Schedule.of(
    int memId,
    DateTime? at,
    NotificationType notificationType,
  ) =>
      v(
        () {
          final scheduleId = _buildScheduleId(notificationType, memId);

          return at == null
              ? CancelSchedule(
                  scheduleId,
                )
              : TimedSchedule(
                  scheduleId,
                  at,
                  {
                    memIdKey: memId,
                    notificationTypeKey: notificationType.name,
                  },
                );
        },
        {
          'id': memId,
          'at': at,
          'notificationType': notificationType,
        },
      );

  static int _buildScheduleId(
    NotificationType notificationType,
    int memId,
  ) =>
      v(
        () => notificationType.buildNotificationId(memId),
        {
          'notificationType': notificationType,
          'memId': memId,
        },
      );

  @override
  String toString() => "${super.toString()}: ${{
        "id": id,
      }}";
}

class CancelSchedule extends Schedule {
  CancelSchedule(super.id);
}

class TimedSchedule extends Schedule {
  final DateTime startAt;
  final Map<String, dynamic> params;

  TimedSchedule(
    super.id,
    this.startAt,
    this.params,
  );

  @override
  String toString() => "${super.toString()}${{
        "startAt": startAt,
        "params": params,
      }}";
}

class PeriodicSchedule extends TimedSchedule {
  final Duration duration;

  PeriodicSchedule(
    super.id,
    super.startAt,
    this.duration,
    super.params,
  );

  @override
  String toString() => "${super.toString()}${{"duration": duration}}";
}
