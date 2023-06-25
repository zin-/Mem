import 'package:flutter/material.dart';
import 'package:mem/act_counter/act_counter_configure.dart';
import 'package:mem/act_counter/act_counter_repository.dart';
import 'package:mem/act_counter/act_counter_service.dart';
import 'package:mem/acts/act_repository.dart';
import 'package:mem/core/date_and_time.dart';
import 'package:mem/database/table_definitions/acts.dart';
import 'package:mem/database/table_definitions/mem_items.dart';
import 'package:mem/database/table_definitions/mems.dart';
import 'package:mem/framework/database/database_manager.dart';
import 'package:mem/database/definition.dart';
import 'package:mem/gui/app.dart';
import 'package:mem/logger/log_service_v2.dart' as v2;
import 'package:mem/mems/mem_item_repository_v2.dart';
import 'package:mem/mems/list/page.dart';
import 'package:mem/mems/mem_repository_v2.dart';

import 'logger/i/api.dart';

Future<void> main({String? languageCode}) async {
  initializeLogger();
  run(const MemListPage(), languageCode: languageCode);
}

@pragma('vm:entry-point')
Future<void> launchActCounterConfigure() async {
  initializeLogger();
  run(const ActCounterConfigure());
}

Future<void> run(Widget home, {String? languageCode}) => t(
      {'home': home, 'languageCode': languageCode},
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        await openDatabase();
        initializeActCounter();

        runApp(MemApplication(home, languageCode));
      },
    );

Future<void> openDatabase() async {
  final database = await DatabaseManager().open(databaseDefinition);

  MemRepository(
    database.getTable(memTableDefinition.name),
  );
  MemItemRepository(
    database.getTable(memItemTableDefinition.name),
  );
  ActRepository(
    database.getTable(actTableDefinition.name),
  );
}

const uriSchema = 'mem';
const appId = 'zin.playground.mem';
const actCounter = 'act_counters';
const memIdParamName = 'mem_id';

void backgroundCallback(Uri? uri) => v2.v(
      () async {
        if (uri != null && uri.scheme == uriSchema && uri.host == appId) {
          await openDatabase();

          if (uri.pathSegments.contains(actCounter)) {
            final memId = uri.queryParameters[memIdParamName];

            if (memId != null) {
              await ActCounterService().increment(
                int.parse(memId),
                DateAndTime.now(),
              );
            }
          }
        }
      },
      {'uri': uri},
    );
