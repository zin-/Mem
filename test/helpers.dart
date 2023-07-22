import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mem/act_counter/act_counter_repository.dart';
import 'package:mem/act_counter/act_counter_service.dart';
import 'package:mem/act_counter/home_widget_accessor.dart';
import 'package:mem/acts/act_repository.dart';
import 'package:mem/components/l10n.dart';
import 'package:mem/logger/logger_wrapper.dart';
import 'package:mem/mems/mem_item_repository_v2.dart';
import 'package:mem/mems/mem_notification_repository.dart';
import 'package:mem/mems/mem_repository_v2.dart';
import 'package:mem/notifications/notification_repository.dart';
import 'package:mem/notifications/wrapper.dart';
import 'package:mockito/annotations.dart';

bool randomBool() => Random().nextBool();

int randomInt([int max = 42949671]) => Random().nextInt(max);

@GenerateMocks([
  HomeWidgetAccessor,
  LoggerWrapper,
  NotificationsWrapper,
  // FIXME RepositoryではなくTableをmockする
  //  Repositoryはシステム固有の処理であるのに対して、Tableは永続仮想をラップする役割を持つため
  MemRepository,
  MemItemRepository,
  NotificationRepository,
  ActRepository,
  ActCounterRepository,
  ActCounterService,
  MemNotificationRepository,
])
void main() {}

Widget buildTestApp(Widget widget) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // FIXME この仕組みはなくす
      onGenerateTitle: (context) => buildL10n(context).test,
      home: widget,
    );

Widget buildTestAppWithProvider(
  Widget widget, {
  List<Override>? overrides,
}) =>
    ProviderScope(
      overrides: overrides ?? [],
      child: buildTestApp(widget),
    );

class TestCase<T> {
  final String name;
  final T input;
  final Function(T input) verify;

  TestCase(this.name, this.input, this.verify);
}
