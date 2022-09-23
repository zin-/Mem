import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:mem/l10n.dart';
import 'package:mem/logger.dart';
import 'package:mem/repositories/mem_repository.dart';
import 'package:mem/views/mem_list/mem_list_page.dart';

import '../mocks.mocks.dart';
import 'mem_detail/mem_detail_body_test.dart';

Future pumpMemListPage(WidgetTester widgetTester) async {
  await widgetTester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        onGenerateTitle: (context) => L10n(context).memListPageTitle(),
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: MemListPage(),
      ),
    ),
  );
  await widgetTester.pumpAndSettle();
}

void main() {
  Logger(level: Level.verbose);

  final mockedMemRepository = MockMemRepository();
  MemRepository.withMock(mockedMemRepository);

  testWidgets(
    'Show saved mem list',
    (widgetTester) async {
      final mems = List.generate(
        5,
        (index) => MemEntity(
          id: index,
          name: 'Test $index',
          createdAt: DateTime.now(),
        ),
      );

      when(mockedMemRepository.ship(archived: anyNamed('archived'))).thenAnswer(
        (realInvocation) async => mems,
      );

      await pumpMemListPage(widgetTester);

      mems.asMap().forEach((index, mem) {
        expectMemNameTextOnListAt(widgetTester, index, mem.name);
      });

      await widgetTester.tap(memListTileFinder.at(0));
      await widgetTester.pump();

      verify(mockedMemRepository.ship(archived: false)).called(1);
      verifyNever(mockedMemRepository.shipById(any));
    },
    tags: 'Small',
  );

  group('Transit', () {
    testWidgets(
      ': new MemDetailPage',
      (widgetTester) async {
        when(mockedMemRepository.ship(archived: anyNamed('archived')))
            .thenAnswer(
          (realInvocation) async => [],
        );

        await pumpMemListPage(widgetTester);

        expect(showNewMemFabFinder, findsOneWidget);
        await widgetTester.tap(showNewMemFabFinder);
        await widgetTester.pumpAndSettle();

        expectMemNameOnMemDetail(widgetTester, '');

        verify(mockedMemRepository.ship(archived: false)).called(1);
        verifyNever(mockedMemRepository.shipById(any));
      },
      tags: 'Small',
    );

    testWidgets(
      ': saved MemDetailPage',
      (widgetTester) async {
        final savedMem1 =
            MemEntity(id: 1, name: 'mem detail', createdAt: DateTime.now());
        final savedMem2 =
            MemEntity(id: 2, name: 'mem list', createdAt: DateTime.now());
        when(mockedMemRepository.ship(archived: anyNamed('archived')))
            .thenAnswer(
          (realInvocation) async => [savedMem1, savedMem2],
        );

        await pumpMemListPage(widgetTester);

        await widgetTester.tap(memListTileFinder.at(0));
        await widgetTester.pumpAndSettle();

        expectMemNameOnMemDetail(widgetTester, savedMem1.name);
        expect(
          (widgetTester.widget(memNameTextFormFieldFinder) as TextFormField)
              .initialValue,
          isNot(savedMem2.name),
        );

        verify(mockedMemRepository.ship(archived: false)).called(1);
        verifyNever(mockedMemRepository.shipById(any));
      },
      tags: 'Small',
    );
  });

  group('Filter', () {
    testWidgets(
      ': default.',
      (widgetTester) async {
        final notArchived = MemEntity(
          id: 1,
          name: 'not archived',
          createdAt: DateTime.now(),
          archivedAt: null,
        );
        final archived = MemEntity(
          id: 1,
          name: 'archived',
          createdAt: DateTime.now(),
          archivedAt: DateTime.now(),
        );
        when(mockedMemRepository.ship(archived: anyNamed('archived')))
            .thenAnswer(
          (realInvocation) async => [notArchived],
        );

        await pumpMemListPage(widgetTester);

        expectMemNameTextOnListAt(widgetTester, 0, notArchived.name);
        expect(find.text(archived.name), findsNothing);

        await widgetTester.tap(memListFilterButton);
        await widgetTester.pump();

        expect(
          (widgetTester.widget(findShowNotArchiveSwitch) as Switch).value,
          true,
        );
        expect(
          (widgetTester.widget(findShowArchiveSwitch) as Switch).value,
          false,
        );

        verify(mockedMemRepository.ship(archived: false)).called(1);
      },
      tags: 'Small',
    );

    testWidgets(
      ': onChanged.',
      (widgetTester) async {
        final notArchived = MemEntity(
          id: 1,
          name: 'not archived',
          createdAt: DateTime.now(),
          archivedAt: null,
        );
        final archived = MemEntity(
          id: 2,
          name: 'archived',
          createdAt: DateTime.now(),
          archivedAt: DateTime.now(),
        );
        final notArchived2 = MemEntity(
          id: 3,
          name: 'not archived 2',
          createdAt: DateTime.now(),
          archivedAt: null,
        );
        final archived2 = MemEntity(
          id: 4,
          name: 'archived 2',
          createdAt: DateTime.now(),
          archivedAt: DateTime.now().add(const Duration(microseconds: 1)),
        );
        final returns = <List<MemEntity>>[
          [notArchived2],
          [archived2],
          [archived2, archived],
          [notArchived2, archived2, notArchived, archived],
        ];
        when(mockedMemRepository.ship(archived: anyNamed('archived')))
            .thenAnswer(
          (realInvocation) async => returns.removeAt(0),
        );

        await pumpMemListPage(widgetTester);

        // showNotArchived: true, showArchived: false
        expect(widgetTester.widgetList(memListTileFinder).length, 1);
        expectMemNameTextOnListAt(widgetTester, 0, notArchived2.name);
        expect(find.text(notArchived.name), findsNothing);
        expect(find.text(archived.name), findsNothing);
        expect(find.text(archived2.name), findsNothing);

        await widgetTester.tap(memListFilterButton);
        await widgetTester.pumpAndSettle();

        // showNotArchived: false, showArchived: false
        await widgetTester.tap(findShowNotArchiveSwitch);
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widgetList(memListTileFinder).length, 2);
        expectMemNameTextOnListAt(widgetTester, 0, notArchived2.name);
        expectMemNameTextOnListAt(widgetTester, 1, archived2.name);
        expect(find.text(notArchived.name), findsNothing);
        expect(find.text(archived.name), findsNothing);

        // showNotArchived: false, showArchived: true
        await widgetTester.tap(findShowArchiveSwitch);
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widgetList(memListTileFinder).length, 2);
        expectMemNameTextOnListAt(widgetTester, 0, archived.name);
        expectMemNameTextOnListAt(widgetTester, 1, archived2.name);
        expect(find.text(notArchived.name), findsNothing);
        expect(find.text(notArchived2.name), findsNothing);

        // showNotArchived: true, showArchived: true
        await widgetTester.tap(findShowNotArchiveSwitch);
        await widgetTester.pumpAndSettle();

        expect(widgetTester.widgetList(memListTileFinder).length, 4);
        expectMemNameTextOnListAt(widgetTester, 0, notArchived.name);
        expectMemNameTextOnListAt(widgetTester, 1, notArchived2.name);
        expectMemNameTextOnListAt(widgetTester, 2, archived.name);
        expectMemNameTextOnListAt(widgetTester, 3, archived2.name);

        verify(mockedMemRepository.ship(archived: anyNamed('archived')))
            .called(4);
      },
      tags: 'Small',
    );
  });

  testWidgets(
    'Hide fab on scroll.',
    (widgetTester) async {
      final mems = List.generate(
        20,
        (index) => MemEntity(
          id: index,
          name: 'Test $index',
          createdAt: DateTime.now(),
        ),
      );

      when(mockedMemRepository.ship(archived: anyNamed('archived'))).thenAnswer(
        (realInvocation) async => mems,
      );

      await pumpMemListPage(widgetTester);

      await widgetTester.dragUntilVisible(
        find.text('Test 10'),
        memListFinder,
        const Offset(0, -500),
      );
      await widgetTester.pumpAndSettle();

      expect(showNewMemFabFinder.hitTestable(), findsNothing);

      await widgetTester.dragUntilVisible(
        find.text('Test 0'),
        memListFinder,
        const Offset(0, 500),
      );
      await widgetTester.pumpAndSettle();

      expect(showNewMemFabFinder.hitTestable(), findsOneWidget);
    },
    tags: 'Small',
  );
}

final memListFinder = find.byType(CustomScrollView);
final memListTileFinder = find.descendant(
  of: memListFinder,
  matching: find.byType(ListTile),
);
final showNewMemFabFinder = find.byType(FloatingActionButton);

Finder findMemNameTextOnListAt(int index) => find.descendant(
      of: memListTileFinder.at(index),
      matching: find.byType(Text),
    );

Text getMemNameTextOnListAt(WidgetTester widgetTester, int index) =>
    widgetTester.widget(findMemNameTextOnListAt(index)) as Text;

void expectMemNameTextOnListAt(
  WidgetTester widgetTester,
  int index,
  String memName,
) =>
    expect(
      getMemNameTextOnListAt(widgetTester, index).data,
      memName,
    );

final memListFilterButton = find.byIcon(Icons.filter_list);
final findShowNotArchiveSwitch = find.byType(Switch).at(0);
final findShowArchiveSwitch = find.byType(Switch).at(1);

Future closeMemListFilter(WidgetTester widgetTester) async {
  // FIXME なんか変な気がする
  await widgetTester.tapAt(const Offset(0, 0));
  await widgetTester.pumpAndSettle();
}
