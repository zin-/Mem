import 'package:mem/database/table_definitions/acts.dart';
import 'package:mem/database/table_definitions/mem_items.dart';
import 'package:mem/database/table_definitions/mem_repeated_notifications.dart';
import 'package:mem/database/table_definitions/mems.dart';
import 'package:mem/framework/database/definitions/definition.dart';

final databaseDefinition = DatabaseDefinition(
  'mem.db',
  6,
  [
    memTableDefinition,
    memItemTableDefinition,
    actTableDefinition,
    memRepeatedNotificationTableDefinition,
  ],
);
