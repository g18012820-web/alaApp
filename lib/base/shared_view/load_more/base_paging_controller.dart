import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/exception/app_exception.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BasePagingController<T> extends PagingController<int, T> {
  BasePagingController({
    this.initialPage = 0,
  }) : super(firstPageKey: initialPage);

  final int initialPage;

  List<T> get items => itemList ?? [];

  set setError(AppException e) => error = e;

  void listen({required VoidCallback onLoadMore}) {
    addPageRequestListener((pageKey) {
      if (pageKey > initialPage) onLoadMore();
    });
  }


}
