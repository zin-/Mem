import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mem/components/mem/mem_name.dart';
import 'package:mem/core/mem_item.dart';
import 'package:mem/databases/definition.dart';
import 'package:mem/databases/table_definitions/base.dart';
import 'package:mem/databases/table_definitions/mem_items.dart';
import 'package:mem/databases/table_definitions/mems.dart';
import 'package:mem/framework/database/accessor.dart';
import 'package:mem/framework/repository/condition/conditions.dart';
import 'package:mem/mems/detail/mem_items_view.dart';
import 'package:mem/mems/detail/remove_mem_action.dart';
import 'package:mem/mems/transitions.dart';

import '../helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testMemoDetailScenario();
}

const _scenarioName = "Memo detail scenario";

void testMemoDetailScenario() => group(
      " $_scenarioName",
      () {
        late final DatabaseAccessor dbA;
        setUpAll(() async {
          dbA = await openTestDatabase(databaseDefinition);
        });

        const insertedMemName = "$_scenarioName - inserted - mem - name";
        const insertedMemMemo = "$_scenarioName - inserted - mem - memo";
        late int insertedMemId;

        setUp(() async {
          await clearAllTestDatabaseRows(databaseDefinition);

          insertedMemId = await dbA.insert(
            defTableMems,
            {
              defColMemsName.name: insertedMemName,
              defColCreatedAt.name: zeroDate,
            },
          );
          await dbA.insert(
            defTableMemItems,
            {
              defFkMemItemsMemId.name: insertedMemId,
              defColMemItemsType.name: MemItemType.memo.name,
              defColMemItemsValue.name: insertedMemMemo,
              defColCreatedAt.name: zeroDate,
            },
          );
        });

        group(
          ": Transit",
          () {
            testWidgets(
              ": new.",
              (widgetTester) async {
                await runApplication();
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(newMemFabFinder);
                await widgetTester.pumpAndSettle();

                final memName =
                    widgetTester.widget<TextFormField>(find.byKey(keyMemName));
                final memMemo =
                    widgetTester.widget<TextFormField>(find.byKey(keyMemMemo));

                expect(memName.initialValue, isEmpty);
                expect(memMemo.initialValue, isEmpty);
              },
            );

            testWidgets(
              ": saved.",
              (widgetTester) async {
                await runApplication();
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.text(insertedMemName));
                await widgetTester.pumpAndSettle();

                final memName =
                    widgetTester.widget<TextFormField>(find.byKey(keyMemName));
                final memMemo =
                    widgetTester.widget<TextFormField>(find.byKey(keyMemMemo));

                expect(memName.initialValue, equals(insertedMemName));
                expect(memMemo.initialValue, equals(insertedMemMemo));
              },
            );
          },
        );

        group(
          ": Remove",
          () {
            testWidgets(
              ": disable on new.",
              (widgetTester) async {
                await runApplication();
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(newMemFabFinder);
                await widgetTester.pumpAndSettle();

                expect(find.byKey(keyRemoveMem), findsNothing);

                await widgetTester.tap(menuButtonIconFinder);
                await widgetTester.pumpAndSettle();

                final removeMem =
                    widgetTester.widget<ListTile>(find.byKey(keyRemoveMem));

                expect(removeMem.enabled, false);
              },
            );

            testWidgets(
              ": cancel.",
              (widgetTester) async {
                await runApplication();
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.text(insertedMemName));
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(menuButtonIconFinder);
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.byKey(keyRemoveMem));
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.byKey(keyCancel));
                await widgetTester.pumpAndSettle();

                final whereIdIs = Equals(defPkId.name, insertedMemId);
                expect(
                  (await dbA.select(
                    defTableMems,
                    where: whereIdIs.where(),
                    whereArgs: whereIdIs.whereArgs(),
                  ))
                      .length,
                  1,
                );
              },
            );

            testWidgets(
              ": exec.",
              (widgetTester) async {
                await runApplication();
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.text(insertedMemName));
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(menuButtonIconFinder);
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.byKey(keyRemoveMem));
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.byKey(keyOk));
                await widgetTester.pumpAndSettle();

                expect(
                  find.text(l10n.removeMemSuccessMessage(insertedMemName)),
                  findsOneWidget,
                );
                expect(
                  find.byKey(keyUndo),
                  findsOneWidget,
                );
                expect(find.text(insertedMemName), findsNothing);

                expect((await dbA.select(defTableMems)).length, 0);
              },
            );

            testWidgets(
              ": undo.",
              (widgetTester) async {
                await runApplication();
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.text(insertedMemName));
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(menuButtonIconFinder);
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.byKey(keyRemoveMem));
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.byKey(keyOk));
                await widgetTester.pumpAndSettle();

                await widgetTester.tap(find.byKey(keyUndo));
                await widgetTester.pumpAndSettle();

                expect(find.text(insertedMemName), findsOneWidget);
                final whereIdIs = Equals(defPkId.name, insertedMemId);
                expect(
                  (await dbA.select(
                    defTableMems,
                    where: whereIdIs.where(),
                    whereArgs: whereIdIs.whereArgs(),
                  ))
                      .length,
                  1,
                );
              },
            );
          },
        );
      },
    );
