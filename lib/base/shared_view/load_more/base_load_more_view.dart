import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'base_paging_controller.dart';

class BaseLoadMoreView<T> extends StatelessWidget {
  final BasePagingController<T> pagingController;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Widget? separator;
  final EdgeInsetsGeometry? padding;
  final bool isGrid;
  final int gridCrossAxisCount;
  final double gridSpacing;

  final Widget? firstPageProgressIndicator;
  final Widget? newPageProgressIndicator;
  final Widget? firstPageErrorIndicator;
  final Widget? newPageErrorIndicator;
  final Widget? noItemsFoundIndicator;

  final bool shrinkWrap;
  final bool addAutomaticKeepAlives;
  final Axis scrollDirection;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;

  const BaseLoadMoreView({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    this.separator,
    this.padding,
    this.isGrid = false,
    this.gridCrossAxisCount = 2,
    this.gridSpacing = 8.0,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicator,
    this.firstPageErrorIndicator,
    this.newPageErrorIndicator,
    this.noItemsFoundIndicator,
    this.shrinkWrap = false,
    this.addAutomaticKeepAlives = true,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>.separated(
      pagingController: pagingController,
      padding: padding ?? EdgeInsets.zero,
      shrinkWrap: shrinkWrap,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      scrollDirection: scrollDirection,
      scrollController: scrollController,
      physics: physics,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: itemBuilder,
        animateTransitions: true,
        firstPageProgressIndicatorBuilder: (_) => firstPageProgressIndicator ?? _buildLoadingIndicator(),
        newPageProgressIndicatorBuilder: (_) => newPageProgressIndicator ?? _buildLoadingIndicator(),
        firstPageErrorIndicatorBuilder: (_) => firstPageErrorIndicator ?? _buildErrorIndicator(),
        newPageErrorIndicatorBuilder: (_) => newPageErrorIndicator ?? _buildErrorIndicator(),
        noItemsFoundIndicatorBuilder: (_) => noItemsFoundIndicator ?? _buildEmptyIndicator(),
      ),
      separatorBuilder: (context, index) => separator ?? const SizedBox.shrink(),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorIndicator() {
    return const Center(child: Text("An error has occurred! Please try again."));
  }

  Widget _buildEmptyIndicator() {
    return const Center(child: Text("No data available."));
  }
}
