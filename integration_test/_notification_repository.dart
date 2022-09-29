import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mem/repositories/notification_repository.dart';

void testNotificationRepository() {
  group('NotificationRepository test', () {
    if (Platform.isAndroid) {
      group(
        'Create instance',
        () {
          test(
            ': no initialized',
            () {
              expect(
                () => NotificationRepository(),
                throwsA((e) => e is Exception),
              );
            },
            tags: 'Medium',
          );

          test(
            ': initialized',
            () {
              final initialized = NotificationRepository.initialize();

              final notificationRepository = NotificationRepository();

              expect(notificationRepository, initialized);
            },
            tags: 'Medium',
          );
        },
      );

      group(
        'Operating',
        () {
          late NotificationRepository notificationRepository;

          setUpAll(() {
            notificationRepository = NotificationRepository.initialize();
          });

          testWidgets(
            ': receive',
            (widgetTester) async {
              await notificationRepository.receive(
                1,
                'title',
                DateTime.now().add(const Duration(days: 1)),
              );

              // dev(result);
              // TODO 通知されていることをcheckする
            },
            tags: 'Medium',
          );
        },
      );
    }
  });
}
