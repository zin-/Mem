import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/logger/api.dart';
import 'package:mem/view/_atom/state_notifier.dart'; // TODO move

import '../domain/act.dart';
import '../domain/date_and_time_period.dart';

final actListProvider =
    StateNotifierProvider<ListValueStateNotifier<Act>, List<Act>?>(
  (ref) => v(
    {},
    () {
      final actList = ListValueStateNotifier<Act>(null);

      Future.delayed(
        const Duration(seconds: 20),
        () => List.generate(
          20,
          (index) => Act(
            DateAndTimePeriod.startNow(),
          ),
        ),
      ).then((value) => actList.updatedBy(value));

      return actList;
    },
  ),
);
