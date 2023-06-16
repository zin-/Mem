import 'package:flutter_test/flutter_test.dart';
import 'package:mem/database/database.dart';
import 'package:mem/framework/database/definition.dart';
import 'package:mem/database/indexed_database.dart';

void main() {
  test(
    'Indexed database: require at least 1 table.',
    () async {
      final defD = DatabaseDefinition('test.db', 1, []);
      expect(
        () => IndexedDatabase(defD),
        throwsA(
          (e) =>
              e is DatabaseException &&
              e.message == 'Requires at least 1 table.',
        ),
      );
    },
  );
}
