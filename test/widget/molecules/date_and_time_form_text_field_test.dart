import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mem/domains/date_and_time.dart';
import 'package:mem/views/atoms/date_and_time_view.dart';
import 'package:mem/views/molecules/date_and_time_text_form_field.dart';

import '../../_helpers.dart';

void main() {
  group('Appearance', () {
    testWidgets(
      ': date and time is null',
      (widgetTester) async {
        const dateAndTime = null;

        await runWidget(
          widgetTester,
          DateAndTimeTextFormFieldV2(
            dateAndTime,
            (pickedDateAndTime) => fail('should not be called'),
          ),
        );

        expect(dateTextFormFieldFinder, findsOneWidget);
        expect(timeOfDayTextFormFieldFinder, findsNothing);
        expect(clearButtonFinder, findsNothing);
      },
      tags: TestSize.small,
    );

    testWidgets(
      ': all day',
      (widgetTester) async {
        final dateAndTime = DateAndTime.now(allDay: true);

        await runWidget(
          widgetTester,
          DateAndTimeTextFormFieldV2(
            dateAndTime,
            (pickedDateAndTime) => fail('should not be called'),
          ),
        );

        expect(dateTextFormFieldFinder, findsOneWidget);
        expect(timeOfDayTextFormFieldFinder, findsNothing);
        expect(clearButtonFinder, findsOneWidget);
      },
      tags: TestSize.small,
    );

    testWidgets(
      ': is not all day',
      (widgetTester) async {
        final dateAndTime = DateAndTime.now(allDay: false);

        await runWidget(
          widgetTester,
          DateAndTimeTextFormFieldV2(
            dateAndTime,
            (pickedDateAndTime) => fail('should not be called'),
          ),
        );

        expect(dateTextFormFieldFinder, findsOneWidget);
        expect(timeOfDayTextFormFieldFinder, findsOneWidget);
        expect(clearButtonFinder, findsOneWidget);
      },
      tags: TestSize.small,
    );
  });

  group('Operation', () {
    testWidgets(
      ': clear',
      (widgetTester) async {
        final dateAndTime = DateAndTime.now(allDay: true);

        await runWidget(
          widgetTester,
          DateAndTimeTextFormFieldV2(
            dateAndTime,
            (pickedDateAndTime) {
              expect(pickedDateAndTime, null);
            },
          ),
        );

        await widgetTester.tap(clearButtonFinder);
      },
      tags: TestSize.small,
    );
  });
}

final dateTextFormFieldFinder = find.byType(DateTextFormFieldV2);
final timeOfDayTextFormFieldFinder = find.byType(TimeOfDayTextFormFieldV2);
final clearButtonFinder = find.byIcon(Icons.clear);
