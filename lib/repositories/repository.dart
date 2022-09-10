import 'package:mem/database/database.dart';
import 'package:mem/database/definitions.dart';
import 'package:mem/logger.dart';

const idColumnName = 'id';
const createdAtColumnName = 'createdAt';
const updatedAtColumnName = 'updatedAt';
const archivedAtColumnName = 'archivedAt';

abstract class DatabaseTableRepository<Entity extends DatabaseTableEntity> {
  Future<Entity> receive(Map<String, dynamic> valueMap) => v(
        {'valueMap': valueMap},
        () async {
          final insertingMap = valueMap
            ..putIfAbsent(createdAtColumnName, () => DateTime.now());

          final id = await table.insert(insertingMap);

          return fromMap(insertingMap..putIfAbsent(idColumnName, () => id));
        },
      );

  Future<List<Entity>> ship({bool? archived}) => v(
        {'archived': archived},
        () async {
          final where = <String>[];

          if (archived != null) {
            archived
                ? where.add('archivedAt IS NOT NULL')
                : where.add('archivedAt IS NULL');
          }

          return (await table.select(
            where: where.isEmpty ? null : where.join(' AND '),
          ))
              .map((e) => fromMap(e))
              .toList();
        },
      );

  Future<Entity> shipById(dynamic id) => v(
        {'id': id},
        () async => fromMap(await table.selectByPk(id)),
      );

  Future<Entity> update(Entity entity) => v(
        {'entity': entity},
        () async {
          final valueMap = entity.toMap();
          valueMap[updatedAtColumnName] = DateTime.now();

          await table.updateByPk(entity.id, valueMap);

          return fromMap(valueMap);
        },
      );

  Future<Entity> archive(Entity entity) => v(
        {'entity': entity},
        () async {
          final valueMap = entity.toMap();
          valueMap[archivedAtColumnName] = DateTime.now();

          await table.updateByPk(entity.id, valueMap);

          return fromMap(valueMap);
        },
      );

  Future<Entity> unarchive(Entity entity) => v(
        {'entity': entity},
        () async {
          final valueMap = entity.toMap();
          valueMap[archivedAtColumnName] = null;

          await table.updateByPk(entity.id, valueMap);

          return fromMap(valueMap);
        },
      );

  Future<bool> discardById(dynamic id) => v(
        {'id': id},
        () async {
          int deletedCount = await table.deleteByPk(id);

          return deletedCount == 1;
        },
      );

  Future<int> discardAll() => v(
        {},
        () async => table.delete(),
      );

  Entity fromMap(Map<String, dynamic> valueMap) => v(
        {'valueMap': valueMap},
        () => throw UnimplementedError(),
      );

  Table table; // FIXME be private

  DatabaseTableRepository(this.table);
}

abstract class DatabaseTableEntity {
  late dynamic id;
  late DateTime createdAt;
  late DateTime? updatedAt;
  late DateTime? archivedAt;

  DatabaseTableEntity.fromMap(Map<String, dynamic> valueMap)
      : id = valueMap[idColumnName],
        createdAt = valueMap[createdAtColumnName],
        updatedAt = valueMap[updatedAtColumnName],
        archivedAt = valueMap[archivedAtColumnName];

  Map<String, dynamic> toMap() => {
        idColumnName: id,
        createdAtColumnName: createdAt,
        updatedAtColumnName: updatedAt,
        archivedAtColumnName: archivedAt,
      };

  @override
  String toString() => toMap().toString();
}

final defaultColumnDefinitions = [
  DefC(createdAtColumnName, TypeC.datetime),
  DefC(updatedAtColumnName, TypeC.datetime, notNull: false),
  DefC(archivedAtColumnName, TypeC.datetime, notNull: false),
];
