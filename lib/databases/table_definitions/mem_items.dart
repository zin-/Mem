import 'package:mem/databases/table_definitions/base.dart';
import 'package:mem/databases/table_definitions/mems.dart';
import 'package:mem/framework/database/definition/column_definition.dart';
import 'package:mem/framework/database/definition/column_type.dart';
import 'package:mem/framework/database/definition/foreign_key_definition.dart';
import 'package:mem/framework/database/definition/table_definition.dart';

final memItemTypeColDef = ColumnDefinition('type', ColumnType.text);
final memItemValueColDef = ColumnDefinition('value', ColumnType.text);
final memIdFkDef = ForeignKeyDefinition(memTableDefinition);

final memItemTableDefinition = TableDefinition(
  'mem_items',
  [
    memItemTypeColDef,
    memItemValueColDef,
    ...defaultColumnDefinitions,
    ForeignKeyDefinition(memTableDefinition),
  ],
);