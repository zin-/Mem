import 'package:flutter_test/flutter_test.dart';
import 'package:mem/databases/table_definitions/base.dart';
import 'package:mem/framework/database/definition/column/boolean_column_definition.dart';
import 'package:mem/framework/database/definition/database_definition.dart';
import 'package:mem/framework/database/definition/table_definition.dart';
import 'package:mem/framework/database/factory.dart';
import 'package:mem/framework/repository/condition/conditions.dart';
import 'package:mem/framework/repository/database_tuple_repository.dart';

import '../../test/framework/repository/database_tuple_entity_test.dart';
import '../../test/framework/repository/entity_test.dart';

const _name = "DatabaseTupleRepository tests";

final _defColA = BooleanColumnDefinition(TestObjectEntity.fieldNames[0]);
final _defTableTestObject =
    TableDefinition('test_object', [_defColA, ...defColsBase]);
final _defDbTest = DatabaseDefinition('test_db', 1, [_defTableTestObject]);

class _TestObjectRepository extends DatabaseTupleRepository<TestObjectEntity> {
  _TestObjectRepository() : super(_defDbTest, _defTableTestObject);

  @override
  TestObjectEntity pack(Map<String, dynamic> map) =>
      TestObjectDatabaseTupleEntity.fromMap(map);
}

void main() => group(
      _name,
      () {
        late String databasePath;
        setUpAll(
          () async {
            databasePath =
                await DatabaseFactory.buildDatabasePath(_defDbTest.name);

            await DatabaseFactory
                // ignore: deprecated_member_use_from_same_package
                .nativeFactory
                .deleteDatabase(databasePath);
          },
        );

        test(
          '#new',
          () async {
            _TestObjectRepository();

            expect(
                await DatabaseFactory
                    // ignore: deprecated_member_use_from_same_package
                    .nativeFactory
                    .databaseExists(databasePath),
                false);
          },
        );

        group(
          'operations',
          () {
            final repository = _TestObjectRepository();

            group(
              '#count',
              () {
                setUpAll(
                  () async {
                    final falseSample = TestObjectEntity(false);
                    final trueSample = TestObjectEntity(true);
                    final now = DateTime.now();

                    final dbA = await DatabaseFactory.open(_defDbTest);

                    await dbA.delete(_defTableTestObject);
                    await dbA.insert(_defTableTestObject,
                        falseSample.toMap..addAll({defColCreatedAt.name: now}));
                    await dbA.insert(_defTableTestObject,
                        falseSample.toMap..addAll({defColCreatedAt.name: now}));
                    await dbA.insert(_defTableTestObject,
                        trueSample.toMap..addAll({defColCreatedAt.name: now}));
                  },
                );

                test(
                  ': all.',
                  () async {
                    final count = await repository.count();

                    expect(count, 3);
                  },
                );
                test(
                  ': condition.',
                  () async {
                    final count = await repository.count(
                        condition: Equals(_defColA, false));

                    expect(count, 2);
                  },
                );
              },
            );

            group(
              '#receive',
              () {
                setUpAll(
                  () async {
                    final dbA = await DatabaseFactory.open(_defDbTest);

                    await dbA.delete(_defTableTestObject);
                  },
                );

                test(
                  ': received.',
                  () async {
                    final now = DateTime.now();
                    final entity = TestObjectEntity(false);

                    final received =
                        await repository.receive(entity, createdAt: now);

                    expect(
                        received,
                        equals(TestObjectDatabaseTupleEntity(entity.a).withMap(
                            {defPkId.name: 1, defColCreatedAt.name: now})));
                  },
                );
              },
            );
          },
        );
      },
    );
