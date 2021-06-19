import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mem/app.dart';
import 'package:mem/database/mem_dao.dart';
import 'package:mem/domain/mem_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mem_detail_test.mocks.dart';

@GenerateMocks([MemDao])
void main() {
  testWidgets('Show empty mem detail.',
      (WidgetTester tester) async {
    final mockedMemDao = MockMemDao();
    print('message');
    MemService(memDao: mockedMemDao);
    print('message');
    when(mockedMemDao.selectWhereId(1)).thenAnswer((_) {
      log('5');
      return Future.value(null);
    });

    await tester.pumpWidget(App());

    expect(find.byKey(Key('loading')), findsOneWidget);
    expect(find.byKey(Key('save_fab')), findsOneWidget);

    await tester.pump(new Duration(milliseconds: 500));

    verify(mockedMemDao.selectWhereId(1)).called(1);

    // expect(find.byKey(Key('mem_name')), findsOneWidget);
    // expect(find.byKey(Key('mem_remarks')), findsOneWidget);
  });
}
