import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mem/databases/table_definitions/base.dart';
import 'package:mem/databases/table_definitions/mems.dart';
import 'package:mem/framework/database/database.dart';
import 'package:mem/framework/database/database_manager.dart';
import 'package:mem/databases/definition.dart';
import 'package:mem/values/durations.dart';

import '../_helpers.dart';
import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testTodoScenario();
}

const _scenarioName = 'Todo scenario';

void testTodoScenario() => group(': $_scenarioName', () {
      const insertedMemName = '$_scenarioName - mem name - inserted';

      const undoneMemName = '$_scenarioName - mem name - inserted - undone';
      const doneMemName = '$_scenarioName - mem name - inserted - done';

      late final Database db;

      setUpAll(() async {
        db = await DatabaseManager(onTest: true).open(databaseDefinition);
      });
      setUp(() async {
        await resetDatabase(db);

        final memTable = db.getTable(memTableDefinition.name);
        await memTable.insert({
          defMemName.name: insertedMemName,
          createdAtColDef.name: zeroDate,
        });
        await memTable.insert({
          defMemName.name: undoneMemName,
          defMemDoneAt.name: null,
          createdAtColDef.name: zeroDate,
        });
        await memTable.insert({
          defMemName.name: doneMemName,
          defMemDoneAt.name: zeroDate,
          createdAtColDef.name: zeroDate,
        });
      });

      group(': done & undone', () {
        testWidgets(
          ': MemDetailPage.',
          (widgetTester) async {
            await runApplication();
            await widgetTester.pumpAndSettle();

            expect(find.text(undoneMemName), findsOneWidget);
            expect(find.text(doneMemName), findsNothing);
            await widgetTester.tap(find.text(insertedMemName));
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(find.byType(Checkbox));
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(saveMemFabFinder);
            await widgetTester.pumpAndSettle();
            await widgetTester.pageBack();
            await widgetTester.pumpAndSettle();

            expect(find.text(insertedMemName), findsNothing);
            expect(find.text(undoneMemName), findsOneWidget);
            expect(find.text(doneMemName), findsNothing);
            await widgetTester.tap(memListFilterButton);
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(find.byType(Switch).at(3));
            await closeMemListFilter(widgetTester);
            await widgetTester.pumpAndSettle(defaultTransitionDuration);

            expect(find.text(insertedMemName), findsOneWidget);
            expect(find.text(undoneMemName), findsOneWidget);
            expect(find.text(doneMemName), findsOneWidget);
            await widgetTester.tap(find.text(insertedMemName));
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(find.byType(Checkbox));
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(saveMemFabFinder);
            await widgetTester.pumpAndSettle();
            await widgetTester.pageBack();
            await widgetTester.pumpAndSettle();

            await widgetTester.tap(memListFilterButton);
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(find.byType(Switch).at(2));
            await closeMemListFilter(widgetTester);
            await widgetTester.pumpAndSettle(defaultTransitionDuration);

            expect(find.text(insertedMemName), findsNothing);
            expect(find.text(undoneMemName), findsNothing);
            expect(find.text(doneMemName), findsOneWidget);
          },
        );

        testWidgets(
          ': MemListPage.',
          (widgetTester) async {
            await runApplication();
            await widgetTester.pumpAndSettle();

            expect(find.text(insertedMemName), findsOneWidget);
            expect(find.text(undoneMemName), findsOneWidget);
            expect(find.text(doneMemName), findsNothing);
            await widgetTester.tap(find.byType(Checkbox).at(0));
            await widgetTester.pumpAndSettle();

            expect(find.text(insertedMemName), findsNothing);
            expect(find.text(undoneMemName), findsOneWidget);
            expect(find.text(doneMemName), findsNothing);
            await widgetTester.tap(memListFilterButton);
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(find.byType(Switch).at(2));
            await closeMemListFilter(widgetTester);
            await widgetTester.pumpAndSettle(defaultTransitionDuration);

            expect(find.text(insertedMemName), findsOneWidget);
            expect(find.text(undoneMemName), findsOneWidget);
            expect(find.text(doneMemName), findsOneWidget);
            await widgetTester.tap(find.byType(Checkbox).at(1));
            await widgetTester.pumpAndSettle();

            expect(find.text(insertedMemName), findsOneWidget);
            expect(find.text(undoneMemName), findsOneWidget);
            expect(find.text(doneMemName), findsOneWidget);
            await widgetTester.tap(memListFilterButton);
            await widgetTester.pumpAndSettle();
            await widgetTester.tap(find.byType(Switch).at(3));
            await closeMemListFilter(widgetTester);
            await widgetTester.pumpAndSettle(defaultTransitionDuration);

            expect(find.text(insertedMemName), findsNothing);
            expect(find.text(undoneMemName), findsNothing);
            expect(find.text(doneMemName), findsOneWidget);
          },
        );
      });
    });
