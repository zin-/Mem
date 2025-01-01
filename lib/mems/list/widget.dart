import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mem/acts/act.dart';
import 'package:mem/framework/date_and_time/date_and_time.dart';
import 'package:mem/framework/date_and_time/date_and_time_view.dart';
import 'package:mem/framework/date_and_time/time_of_day.dart';
import 'package:mem/framework/nullable.dart';
import 'package:mem/framework/view/async_value_view.dart';
import 'package:mem/l10n/l10n.dart';
import 'package:mem/logger/log_service.dart';
import 'package:mem/mems/mem_entity.dart';
import 'package:mem/mems/mem_notification_entity.dart';
import 'package:mem/mems/states.dart';
import 'package:mem/mems/transitions.dart';
import 'package:mem/settings/preference/keys.dart';
import 'package:mem/settings/states.dart';
import 'package:mem/values/constants.dart';

import 'actions.dart';
import 'app_bar.dart';
import 'item/view.dart';
import 'states.dart';

class MemListWidget extends ConsumerWidget {
  final ScrollController _scrollController;

  const MemListWidget(this._scrollController, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => v(
        () => AsyncValueView(
          loadMemList,
          (loaded) => _MemListWidget(
            _scrollController,
            ref.watch(memListProvider).toList(),
            ref.watch(preferencesProvider).value?[startOfDayKey] ??
                defaultStartOfDay,
            ref.watch(memNotificationsProvider),
            ref.watch(latestActsByMemProvider),
            (memId) => showMemDetailPage(context, ref, memId),
          ),
        ),
      );
}

class _MemListWidget extends StatelessWidget {
  final ScrollController _scrollController;
  final List<SavedMemEntityV2> _memList;
  final TimeOfDay _startOfDay;
  final Iterable<MemNotificationEntityV2> _memNotifications;
  final Iterable<Act> _latestActsByMem;
  final void Function(int memId) _onItemTapped;

  const _MemListWidget(
    this._scrollController,
    this._memList,
    this._startOfDay,
    this._memNotifications,
    this._latestActsByMem,
    this._onItemTapped,
  );

  @override
  Widget build(BuildContext context) => v(
        () {
          final now = DateTime.now();
          final startOfToday = DateTime(
            now.year,
            now.month,
            now.day,
            _startOfDay.hour,
            _startOfDay.minute,
          ).add(Duration(
            days: _startOfDay.lessThan(TimeOfDay.fromDateTime(now)) ? 0 : 1,
          ));
          final l10n = buildL10n(context);

          final hasActMemList = _memList.groupListsBy(
            (mem) {
              final latestAct = _latestActsByMem.singleWhereOrNull(
                (act) => act.memId == mem.id,
              );
              return latestAct is ActiveAct || latestAct is PausedAct;
            },
          );

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              const MemListAppBar(),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return MemListItemView(
                      hasActMemList[true]![index].id,
                      _onItemTapped,
                    );
                  },
                  childCount: hasActMemList[true]?.length ?? 0,
                ),
              ),
              ...(hasActMemList[false] ?? [])
                  .groupListsBy(
                    (element) {
                      final memNotifications = _memNotifications
                          .where((e) => e.value.memId == element.id)
                          .map((e) => e.value);
                      final nextNotifyAt = element.value.notifyAt(
                        startOfToday,
                        memNotifications,
                        _latestActsByMem.singleWhereOrNull(
                          (act) => act.memId == element.id,
                        ),
                      );

                      if (nextNotifyAt == null) {
                        return null;
                      } else {
                        if (memNotifications
                                .where((e) => !e.isAfterActStarted())
                                .isNotEmpty &&
                            nextNotifyAt.isBefore(startOfToday)) {
                          return DateAndTime(
                            nextNotifyAt.year,
                            nextNotifyAt.month,
                            nextNotifyAt.day,
                          ).add(Duration(days: 1));
                        }

                        return DateAndTime(
                          nextNotifyAt.year,
                          nextNotifyAt.month,
                          nextNotifyAt.day,
                        );
                      }
                    },
                  )
                  .entries
                  .sorted((a, b) => nullableCompare(a.key, b.key))
                  .map(
                    (e) => SliverStickyHeader(
                      header: Container(
                        height: 60.0,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerLeft,
                        child: e.key == null
                            ? Text(l10n.memListToDoSubHeader)
                            : DateAndTimeText(e.key!),
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => MemListItemView(
                            e.value[index].id,
                            _onItemTapped,
                          ),
                          childCount: e.value.length,
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
        {
          '_scrollController': _scrollController,
          '_memList': _memList,
          '_onItemTapped': _onItemTapped,
        },
      );
}
