import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mem/component/view/mem_list/actions.dart';
import 'package:mem/component/view/mem_list/states.dart';
import 'package:mem/core/mem.dart';
import 'package:mem/gui/colors.dart';
import 'package:mem/logger/i/api.dart';

import 'mem_list_item_view.dart';

class MemListView extends ConsumerWidget {
  final String _appBarTitle;
  final ScrollController? _scrollController;
  final List<Widget> _appBarActions;
  final void Function(MemId memId)? _onItemTapped;

  MemListView(
    this._appBarTitle, {
    ScrollController? scrollController,
    List<Widget>? appBarActions,
    void Function(MemId memId)? onItemTapped,
    super.key,
  })  : _scrollController = scrollController,
        _appBarActions = appBarActions ?? [],
        _onItemTapped = onItemTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fetchMemList);

    return _MemListViewComponent(
      _appBarTitle,
      ref.watch(memListProvider),
      _scrollController,
      _appBarActions,
      _onItemTapped,
    );
  }
}

class _MemListViewComponent extends StatelessWidget {
  final String _appBarTitle;
  final List<Mem> _memList;
  final ScrollController? _scrollController;
  final List<Widget> _appBarActions;
  final void Function(MemId memId)? _onItemTapped;

  const _MemListViewComponent(
    this._appBarTitle,
    this._memList,
    this._scrollController,
    this._appBarActions,
    this._onItemTapped,
  );

  @override
  Widget build(BuildContext context) => v(
        {
          '_appBarTitle': _appBarTitle,
          '_memList': _memList,
          '_scrollController': _scrollController,
          '_appBarActions': _appBarActions,
          '_onItemTapped': _onItemTapped,
        },
        () {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                title: Text(_appBarTitle),
                floating: true,
                actions: [
                  IconTheme(
                    data: const IconThemeData(color: iconOnPrimaryColor),
                    child: Row(
                      children: _appBarActions,
                    ),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => MemListItemView(
                    _memList[index].id,
                    _onItemTapped,
                  ),
                  childCount: _memList.length,
                ),
              ),
            ],
          );
        },
      );
}
