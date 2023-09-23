import 'package:mem/framework/database/definition/column/integer_column_definition.dart';
import 'package:mem/framework/database/definition/column/timestamp_column_definition.dart';

final defPkId = IntegerColumnDefinition('id', isPrimaryKey: true);
final defColCreatedAt = TimestampColumnDefinition('createdAt');
final defColUpdatedAt = TimestampColumnDefinition('updatedAt', notNull: false);
final defColArchivedAt =
    TimestampColumnDefinition('archivedAt', notNull: false);

final defColsBase = [
  defPkId,
  defColCreatedAt,
  defColUpdatedAt,
  defColArchivedAt,
];
