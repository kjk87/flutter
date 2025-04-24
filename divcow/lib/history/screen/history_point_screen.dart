import 'dart:developer';

import 'package:divcow/common/components/item_back.dart';
import 'package:divcow/common/utils/colors.dart';
import 'package:divcow/common/utils/http.dart';
import 'package:divcow/history/components/item_point.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HistoryPointScreen extends StatefulWidget {

  const HistoryPointScreen({super.key});

  @override
  State<HistoryPointScreen> createState() => _HistoryPointScreen();
}

class _HistoryPointScreen extends State<HistoryPointScreen> {
  static const _pageSize = 20;

  final PagingController<int, dynamic> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await httpListWithCode(path: '/history/point/list?paging[page]=${pageKey}&paging[limit]=${_pageSize}&order[][column]=seqNo&order[][dir]=DESC');
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DivcowColor.background,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 0,
        titleSpacing: 0,
        backgroundColor: DivcowColor.background,
        title: Container(
            padding: const EdgeInsets.only(
                left: 10, top: 20, right: 10, bottom: 10),
            child: itemBack(context, tr('PointHistory'))
        ),
      ),
      body: PagedListView<int, dynamic>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          itemBuilder: (context, item, index) => itemPoint(item),
          noItemsFoundIndicatorBuilder: (context) => Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: DivcowColor.background,
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Text(tr('pointHistoryNotExist'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: DivcowColor.textDefault,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
