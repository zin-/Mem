import 'package:mem/framework/repository/repository.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/notifications/android_alarm_manager_wrapper.dart';
import 'package:mem/notifications/schedule.dart';

class ScheduleClient extends Repository<Schedule>
    with Receiver<Schedule, void> {
  static ScheduleClient? _instance;
  final AndroidAlarmManagerWrapper _androidAlarmManagerWrapper;

  ScheduleClient._(this._androidAlarmManagerWrapper);

  factory ScheduleClient() => v(
        () => _instance ??= ScheduleClient._(
          AndroidAlarmManagerWrapper(),
        ),
        {
          '_instance': _instance,
        },
      );

  static void resetSingleton() => v(
        () {
          AndroidAlarmManagerWrapper.resetSingleton();
          _instance = null;
        },
        {
          '_instance': _instance,
        },
      );

  @override
  Future<void> receive(Schedule entity) => v(
        () async {
          if (entity is PeriodicSchedule) {
            await _androidAlarmManagerWrapper.periodic(
              entity.duration,
              entity.id,
              entity.callback,
              entity.startAt,
              entity.params,
            );
          } else if (entity is TimedSchedule) {
            await _androidAlarmManagerWrapper.oneShotAt(
              entity.startAt,
              entity.id,
              entity.callback,
              entity.params,
            );
          } else if (entity is CancelSchedule) {
            await discard(entity.id);
          }
        },
        {
          "entity": entity,
        },
      );

  Future<void> discard(int id) => v(
        () async => await _androidAlarmManagerWrapper.cancel(id),
        {"id": id},
      );
}
