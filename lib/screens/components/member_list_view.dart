import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sjym_app/models/member.dart';
import 'package:sjym_app/widgets/member_card.dart';

class MemberListView extends StatefulWidget {
  const MemberListView({super.key, required this.function, required this.searchParam});

  final Future<List<Member>> Function(String, int, List<Member>?) function;
  final String searchParam;

  @override
  State<MemberListView> createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  static const int _pageSize = 10;
  final PagingController<int, Member> _pagingController = PagingController(firstPageKey: 0);

  Future<void> _pageRequestlistener(int pageKey) async {
    try {
      List<Member>? lastResult;

      if (pageKey > 0) {
        lastResult = _pagingController.itemList;
      }

      final List<Member> result = await widget.function(
        widget.searchParam,
        _pageSize,
        lastResult,
      );

      if (result.length < _pageSize) {
        _pagingController.appendLastPage(result);
      } else {
        _pagingController.appendPage(result, pageKey + result.length);
      }
    } catch (error) {
      log(error.toString(), error: error, name: runtimeType.toString());
      debugPrint(error.toString());
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener(_pageRequestlistener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member List"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: PagedListView<int, Member>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Member>(
          itemBuilder: (context, item, index) => MemberCard(member: item),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
  }
}
