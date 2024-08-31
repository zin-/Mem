import 'package:mem/framework/repository/entity.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/notifications/notification_client.dart';
import 'package:mem/notifications/mem_notifications.dart';
import 'package:mem/notifications/notification/type.dart';

abstract class Schedule with Entity {
  final int id;

  Schedule(this.id);

  factory Schedule.of(
    int memId,
    DateTime? at,
    NotificationType notificationType,
  ) =>
      v(
        () => at == null
            ? CancelSchedule(
                notificationType.buildNotificationId(memId),
              )
            : TimedSchedule(
                notificationType.buildNotificationId(memId),
                at,
                {
                  memIdKey: memId,
                  notificationTypeKey: notificationType.name,
                },
              ),
        {
          'id': memId,
          'at': at,
          'notificationType': notificationType,
        },
      );

// coverage:ignore-start
  @override
  // TODO: implement copiedWith
  Entity copiedWith() => throw UnimplementedError();

// coverage:ignore-end

  @override
  Map<String, dynamic> get toMap => {
        'id': id,
      };
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
  Map<String, dynamic> get toMap => super.toMap
    ..addAll({
      'startAt': startAt,
      'params': params,
    });
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
  Map<String, dynamic> get toMap => super.toMap
    ..addAll({
      'duration': duration,
    });
}
