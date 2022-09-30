import 'package:integration_test/integration_test.dart';
import 'package:mem/logger.dart';
import 'package:mem/database/database_factory.dart';

import '_database_tuple_repository.dart';
import '_edge_scenario.dart';
import '_memo_scenario.dart';
import '_notification_repository.dart';
import '_todo_scenario.dart';

const defaultDuration = Duration(seconds: 1);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Logger(level: Level.verbose);
  DatabaseManager(onTest: true);

  testDatabaseTupleRepository();
  testNotificationRepository();

  testMemoScenario();
  testTodoScenario();

  testEdgeScenario();
}
