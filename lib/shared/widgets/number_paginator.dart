import 'package:flutter/material.dart';

// 1. CHUYỂN SANG STATEFULWIDGET
class NumberPaginator extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Future<void> Function(int newPage) onPageChange;

  const NumberPaginator(
      {super.key,
      required this.currentPage,
      required this.totalPages,
      required this.onPageChange});

  @override
  State<NumberPaginator> createState() => _NumberPaginatorState();
}

class _NumberPaginatorState extends State<NumberPaginator> {
  late final ScrollController _scrollController;

  static const double _itemWidth = 40.0;
  static const double _separatorWidth = 5.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToSelectedPage(animate: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); 
    super.dispose();
  }

  @override
  void didUpdateWidget(NumberPaginator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentPage != widget.currentPage) {
      _scrollToSelectedPage(animate: true); // animate: có animation
    }
  }

  void _scrollToSelectedPage({required bool animate}) {
    if (!_scrollController.hasClients) return;

    final int pageIndex = widget.currentPage - 1;
    final double offset = pageIndex * (_itemWidth + _separatorWidth);

    if (animate) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 40,
      child: Row(
        children: [
          // Nút Previous
          GestureDetector(
              onTap: (widget.currentPage > 1)
                  ? () async => await widget.onPageChange(widget.currentPage - 1)
                  : null,
              child: Icon(
                Icons.navigate_before,
                color: (widget.currentPage > 1)
                    ? theme.primaryColor
                    : Colors.grey,
              )),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(), // Tránh cuộn lố
              itemBuilder: (context, index) {
                final actualPage = index + 1;
                final isSelectedPage = widget.currentPage == actualPage;

                return GestureDetector(
                  onTap: isSelectedPage
                      ? null
                      : () => widget.onPageChange(actualPage),
                  child: Container(
                    width: _itemWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelectedPage
                            ? theme.primaryColor
                            : Colors.transparent),
                    child: Text(
                      '$actualPage',
                      style: TextStyle(
                          color: isSelectedPage
                              ? Colors.white
                              : theme.primaryColor),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                width: _separatorWidth,
              ),
              itemCount: widget.totalPages,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          // Nút Next
          GestureDetector(
              onTap: (widget.currentPage < widget.totalPages)
                  ? () async => await widget.onPageChange(widget.currentPage + 1)
                  : null,
              child: Icon(
                Icons.navigate_next,
                color: (widget.currentPage < widget.totalPages)
                    ? theme.primaryColor
                    : Colors.grey,
              )),
        ],
      ),
    );
  }
}