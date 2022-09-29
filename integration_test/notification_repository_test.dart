import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mem/logger.dart';
import 'package:mem/repositories/notification_repository.dart';

import '_helpers.dart';

void main() {
  if (Platform.isAndroid) {
    Logger(level: Level.verbose);

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('Create instance', () {
      test(
        ': no initialized',
        () {
          runEmptyApplication();

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
          runEmptyApplication();

          final initialized = NotificationRepository.initialize();

          final notificationRepository = NotificationRepository();

          expect(notificationRepository, initialized);
        },
        tags: 'Medium',
      );
    });

    group('Operating', () {
      late NotificationRepository notificationRepository;

      setUpAll(() {
        notificationRepository = NotificationRepository.initialize();
      });

      testWidgets(
        ': receive',
        (widgetTester) async {
          runEmptyApplication();

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
    });
  }
}
