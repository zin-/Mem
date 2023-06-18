import 'package:mem/framework/database/column_definition.dart';

import '_entity_v2.dart';
import 'types.dart';

const AttributeName idColumnName = 'id';
const AttributeName createdAtColumnName = 'createdAt';
const AttributeName updatedAtColumnName = 'updatedAt';
const AttributeName archivedAtColumnName = 'archivedAt';

final defaultColumnDefinitions = [
  ColumnDefinition(createdAtColumnName, ColumnType.datetime),
  ColumnDefinition(updatedAtColumnName, ColumnType.datetime, notNull: false),
  ColumnDefinition(archivedAtColumnName, ColumnType.datetime, notNull: false),
];

abstract class DatabaseTupleEntity implements EntityV2 {
  dynamic id;
  DateTime? createdAt;
  late DateTime? updatedAt;
  late DateTime? archivedAt;

  DatabaseTupleEntity({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
  });

  DatabaseTupleEntity.fromMap(Map<String, dynamic> valueMap)
      : id = valueMap[idColumnName],
        createdAt = valueMap[createdAtColumnName],
        updatedAt = valueMap[updatedAtColumnName],
        archivedAt = valueMap[archivedAtColumnName];

  @override
  Map<AttributeName, dynamic> toMap() => {
        idColumnName: id,
        createdAtColumnName: createdAt,
        updatedAtColumnName: updatedAt,
        archivedAtColumnName: archivedAt,
      };
}
