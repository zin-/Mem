import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mem/components/l10n.dart';
import 'package:mem/mems/mem_item_repository_v2.dart';
import 'package:mem/mems/mem_repository_v2.dart';
import 'package:mem/notifications/notification_repository.dart';
import 'package:mem/mems/detail/page.dart';
import 'package:mockito/mockito.dart';

import '../helpers.mocks.dart';

void main() {
  final mockedMemRepository = MockMemRepository();
  MemRepository.resetWith(mockedMemRepository);
  final mockedMemItemRepository = MockMemItemRepository();
  MemItemRepository.resetWith(mockedMemItemRepository);
  final mockedNotificationRepository = MockNotificationRepository();
  NotificationRepository.reset(mockedNotificationRepository);

  tearDown(() {
    reset(mockedMemRepository);
    reset(mockedMemItemRepository);
    reset(mockedNotificationRepository);
  });

  group('Save', () {
    testWidgets(
      ': name is required.',
      (widgetTester) async {
        await pumpMemDetailPage(widgetTester, null);

        await widgetTester.tap(saveFabFinder);

        expect(find.text('Name is required'), findsNothing);

        verifyNever(mockedMemRepository.shipById(any));
        verifyNever(mockedMemRepository.receive(any));
      },
    );
  });
}

Future pumpMemDetailPage(
  WidgetTester widgetTester,
  int? memId,
) async {
  await widgetTester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle: (context) => buildL10n(context).test,
        home: MemDetailPage(memId),
      ),
    ),
  );
  await widgetTester.pumpAndSettle();
}

final saveFabFinder = find.byIcon(Icons.save_alt).at(0);

Finder saveMemSuccessFinder(String memName) =>
    find.text('Save success. $memName');
