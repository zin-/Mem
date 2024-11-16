import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mem/framework/view/timer.dart';
import 'package:mem/mems/mem_notification.dart';
import 'package:mem/databases/definition.dart';
import 'package:mem/databases/table_definitions/acts.dart';
import 'package:mem/databases/table_definitions/base.dart';
import 'package:mem/databases/table_definitions/mem_notifications.dart';
import 'package:mem/databases/table_definitions/mems.dart';
import 'package:mem/framework/database/accessor.dart';

import '../helpers.dart';

const _name = "MemListPage scenario";

void main() => group(
      _name,
      () {
        const insertedMemNameBase = '$_name: inserted mem - name';
        const memWithActiveName = "$insertedMemNameBase - active";
        const plainMemName = "$insertedMemNameBase - plain";

        late final DatabaseAccessor dbA;

        setUpAll(() async {
          dbA = await openTestDatabase(databaseDefinition);
        });

        int? insertedMemId;

        setUp(() async {
          await clearAllTestDatabaseRows(databaseDefinition);

          insertedMemId = await dbA.insert(
            defTableMems,
            {
              defColMemsName.name: memWithActiveName,
              defColCreatedAt.name: zeroDate,
            },
          );
          await dbA.insert(
            defTableMemNotifications,
            {
              defFkMemNotificationsMemId.name: insertedMemId,
              defColMemNotificationsTime.name: 1,
              defColMemNotificationsType.name:
                  MemNotificationType.afterActStarted.name,
              defColMemNotificationsMessage.name:
                  '$_name: mem notification message',
              defColCreatedAt.name: zeroDate,
            },
          );
          await dbA.insert(defTableActs, {
            defFkActsMemId.name: insertedMemId,
            defColActsStart.name: zeroDate,
            defColActsStartIsAllDay.name: false,
            defColCreatedAt.name: zeroDate,
          });

          final insertedPlainMemId = await dbA.insert(defTableMems, {
            defColMemsName.name: plainMemName,
            defColCreatedAt.name: zeroDate,
          });
          await dbA.insert(
            defTableMemNotifications,
            {
              defFkMemNotificationsMemId.name: insertedPlainMemId,
              defColMemNotificationsTime.name: 60,
              defColMemNotificationsType.name:
                  MemNotificationType.afterActStarted.name,
              defColMemNotificationsMessage.name:
                  '$_name: mem notification message',
              defColCreatedAt.name: zeroDate,
            },
          );
          await dbA.insert(defTableActs, {
            defFkActsMemId.name: insertedPlainMemId,
            defColActsStart.name: zeroDate,
            defColActsStartIsAllDay.name: false,
            defColActsEnd.name: zeroDate,
            defColActsEndIsAllDay.name: false,
            defColCreatedAt.name: zeroDate,
          });
        });

        group(
          ': act',
          () {
            group(
              ': show',
              () {
                testWidgets(
                  ': plain.',
                  (widgetTester) async {
                    await runApplication();
                    await widgetTester.pumpAndSettle();

                    final memListItemFinder = find.byType(ListTile).at(1);

                    expect(
                      widgetTester
                          .widgetList<Text>(
                            find.descendant(
                              of: memListItemFinder,
                              matching: find.byType(Text),
                            ),
                          )
                          .first
                          .data,
                      plainMemName,
                    );
                    expect(
                      find.descendant(
                        of: memListItemFinder,
                        matching: find.byIcon(Icons.play_arrow),
                      ),
                      findsOneWidget,
                    );

                    expect(
                      find.descendant(
                        of: memListItemFinder,
                        matching: find.byIcon(Icons.stop),
                      ),
                      findsNothing,
                    );
                    expect(
                      find.descendant(
                        of: memListItemFinder,
                        matching: find.byIcon(Icons.pause),
                      ),
                      findsNothing,
                    );
                  },
                );

                testWidgets(
                  ': active.',
                  (widgetTester) async {
                    await runApplication();
                    await widgetTester.pumpAndSettle();

                    final memListItemFinder = find.byType(ListTile).at(0);

                    expect(
                      widgetTester
                          .widgetList<Text>(
                            find.descendant(
                              of: memListItemFinder,
                              matching: find.byType(Text),
                            ),
                          )
                          .first
                          .data,
                      memWithActiveName,
                    );
                    expect(
                      find.descendant(
                        of: memListItemFinder,
                        matching: find.byIcon(Icons.stop),
                      ),
                      findsOneWidget,
                    );
                    expect(
                      find.descendant(
                        of: memListItemFinder,
                        matching: find.byIcon(Icons.pause),
                      ),
                      findsOneWidget,
                    );

                    expect(
                      find.descendant(
                        of: memListItemFinder,
                        matching: find.byIcon(Icons.play_arrow),
                      ),
                      findsNothing,
                    );
                  },
                );
              },
            );

            group(
              ': actions',
              () {
                testWidgets(
                  'start.',
                  // 時間に関するテストなのでリトライ可能とする
                  retry: maxRetryCount,
                  (widgetTester) async {
                    widgetTester.ignoreMockMethodCallHandler(
                      MethodChannelMock.permissionHandler,
                    );
                    widgetTester.ignoreMockMethodCallHandler(
                      MethodChannelMock.flutterLocalNotifications,
                    );

                    await runApplication();
                    await widgetTester.pumpAndSettle();

                    await widgetTester.tap(startIconFinder);
                    await widgetTester.pumpAndSettle();

                    expect(
                      widgetTester.widget<Text>(find.byType(Text).at(1)).data,
                      "00:00:00",
                    );

                    expect(startIconFinder, findsNothing);
                    expect(stopIconFinder, findsNWidgets(2));
                    await widgetTester.pumpAndSettle(elapsePeriod * 2);

                    expect(find.text("00:00:00"), findsNothing);
                  },
                );

                testWidgets(
                  'finish.',
                  (widgetTester) async {
                    widgetTester.ignoreMockMethodCallHandler(
                      MethodChannelMock.permissionHandler,
                    );
                    widgetTester.ignoreMockMethodCallHandler(
                      MethodChannelMock.flutterLocalNotifications,
                    );

                    await runApplication();
                    await widgetTester.pumpAndSettle();

                    await widgetTester.tap(stopIconFinder);
                    await widgetTester.pump(waitSideEffectDuration);

                    expect(startIconFinder, findsNWidgets(2));
                    expect(stopIconFinder, findsNothing);
                  },
                );
              },
            );
          },
        );
      },
    );
