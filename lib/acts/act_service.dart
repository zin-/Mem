import 'package:mem/acts/act_repository.dart';
import 'package:mem/core/act.dart';
import 'package:mem/core/date_and_time/date_and_time_period.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/notifications/channels.dart';
import 'package:mem/notifications/notification/show_notification.dart';
import 'package:mem/notifications/notification_ids.dart';
import 'package:mem/notifications/notification_repository.dart';

class ActService {
  final ActRepository _actRepository;
  final NotificationRepository _notificationRepository;

  Future<Act> startBy(int memId) => i(
        () async {
          final received = await _actRepository.receive(
            Act(
              memId,
              DateAndTimePeriod.startNow(),
            ),
          );

          _notificationRepository.receive(
            ShowNotification(
              activeActNotificationId(memId),
              // TODO memName
              'title',
              // TODO l10n
              'body',
              // TODO mem詳細を表示する
              'payloadJson',
              [
                // TODO finishAct
              ],
              // TODO スワイプで消せないようにする
              activeActNotificationChannel,
            ),
          );

          return received;
        },
        memId,
      );

  ActService._(
    this._actRepository,
    this._notificationRepository,
  );

  static ActService? _instance;

  factory ActService() => _instance ??= _instance = ActService._(
        ActRepository(),
        NotificationRepository(),
      );
}
