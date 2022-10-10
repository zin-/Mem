import 'package:flutter/foundation.dart';
import 'package:mem/repositories/log_repository.dart';
import 'package:mem/services/log_service.dart';

const _filePath = 'mem/logger';

LogService _logService = LogService(Level.error);

void initializeLogger() {
  const level = kDebugMode ? Level.trace : Level.error;
  LogService.reset();
  _logService = LogService(
    level,
    ignoreFilePaths: [_filePath],
  );
}

T v<T>(
  Map<String, dynamic>? arguments,
  T Function() function, {
  @Deprecated('Allow under develop only') bool debug = false,
}) =>
    _logService.functionLog(
      function,
      arguments: arguments,
      level: debug ? Level.debug : Level.verbose,
    );

T t<T>(
  Map<String, dynamic>? args,
  T Function() function, {
  @Deprecated('Allow under develop only') bool debug = false,
}) =>
    _logService.functionLog(
      function,
      arguments: args,
      level: debug ? Level.debug : Level.trace,
    );

T trace<T>(T object) {
  _logService.log(object, level: Level.trace);
  return object;
}

T warn<T>(T object) {
  _logService.log(object, level: Level.warning);
  return object;
}

@Deprecated('Allow under develop only')
T dev<T>(T object) {
  _logService.log(object, level: Level.debug);
  return object;
}
