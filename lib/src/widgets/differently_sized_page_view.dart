import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'widgets.dart';

// TODO: Fix scrolling when using different sized children
class DifferentlySizedPageView extends StatefulWidget {
  const DifferentlySizedPageView({
    super.key,
    required this.children,
    this.padding,
  });

  final EdgeInsetsGeometry? padding;
  final List<Widget> children;

  @override
  State<DifferentlySizedPageView> createState() =>
      _DifferentlySizedPageViewState();
}

class _DifferentlySizedPageViewState extends State<DifferentlySizedPageView> {
  final _controller = ScrollController();
  List<double> _childrenSizes = [];

  @override
  void initState() {
    super.initState();
    _childrenSizes = List.filled(widget.children.length, 0);
  }

  @override
  void didUpdateWidget(covariant DifferentlySizedPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      final newWidths = List<double>.filled(widget.children.length, 0);
      final widthsToCopy = min(newWidths.length, _childrenSizes.length);
      for (int i = 0; i < widthsToCopy; i++) {
        newWidths[i] = _childrenSizes[i];
      }
      _childrenSizes = newWidths;
    }
  }

  void _updateChildSize(int childIndex, Size size) {
    if (childIndex < _childrenSizes.length) {
      setState(() {
        _childrenSizes[childIndex] = size.width;
      });
    }
  }

  double _calculatePageWidth() {
    if (!_controller.hasClients) {
      return _childrenSizes.first;
    }
    final currentPage =
        _getPageFromChildren(_childrenSizes, _controller.position.pixels);
    final totalChildren = _childrenSizes.length;
    switch (_controller.position.userScrollDirection) {
      case ScrollDirection.reverse:
        final clampedCurrentPage =
            currentPage.floor().clamp(0, totalChildren - 1);
        if (clampedCurrentPage == totalChildren - 1) {
          return _childrenSizes[clampedCurrentPage];
        }
        final nextPage = clampedCurrentPage + 1;
        final currentPageFraction = currentPage - currentPage.floor();
        final nextPageFraction = nextPage - currentPage;
        final currentPageWidth = _childrenSizes[clampedCurrentPage];
        final nextPageWidth = _childrenSizes[nextPage];
        return currentPageWidth * currentPageFraction +
            nextPageWidth * nextPageFraction;
      case ScrollDirection.forward:
        final clampedCurrentPage =
            currentPage.ceil().clamp(0, totalChildren - 1);
        if (clampedCurrentPage == 0) {
          return _childrenSizes[clampedCurrentPage];
        }
        final nextPage = clampedCurrentPage - 1;
        final currentPageFraction = currentPage.ceil() - currentPage;
        final nextPageFraction = currentPage - nextPage;
        final currentPageWidth = _childrenSizes[clampedCurrentPage];
        final nextPageWidth = _childrenSizes[nextPage];
        return currentPageWidth * currentPageFraction +
            nextPageWidth * nextPageFraction;
      case ScrollDirection.idle:
        final clampedCurrentPage =
            currentPage.round().clamp(0, totalChildren - 1);
        return _childrenSizes[clampedCurrentPage];
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final pageWidth = _calculatePageWidth();
              final remainingWidth =
                  maxWidth - pageWidth - (widget.padding?.horizontal ?? 0);
              final horizontalSpacing = max(remainingWidth / 2, 0.0);
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: horizontalSpacing)
                    .add(widget.padding ?? EdgeInsets.zero),
                controller: _controller,
                physics: _ScrollPhysics(() => _childrenSizes),
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < widget.children.length; i++)
                    SizeChangeDetector(
                      onSizeChanged: (size) => _updateChildSize(i, size),
                      child: widget.children[i],
                    ),
                ],
              );
            });
      },
    );
  }
}

class _ScrollPhysics extends ScrollPhysics {
  const _ScrollPhysics(
    this._childrenSizes, {
    super.parent,
  });

  final List<double> Function() _childrenSizes;
  List<double> get childrenSizes => _childrenSizes();

  @override
  _ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _ScrollPhysics(
      _childrenSizes,
      parent: buildParent(ancestor),
    );
  }

  double _getPage(ScrollMetrics position) {
    return _getPageFromChildren(childrenSizes, position.pixels);
  }

  double _getPixels(ScrollMetrics position, double page) {
    double completePagesPixels =
        childrenSizes.take(page.floor()).fold(0, (acc, v) => acc + v);
    final remainingPageFraction = page - page.floor();
    final remainingPagePixels =
        childrenSizes[page.floor()] * remainingPageFraction;
    return completePagesPixels + remainingPagePixels;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

double _getPageFromChildren(List<double> childrenSizes, double pixels) {
  double totalPixels = 0;
  for (int i = 0; i < childrenSizes.length; i++) {
    final size = childrenSizes[i];
    final pixelsDifference = pixels - totalPixels;
    if (pixelsDifference < size) {
      return pixelsDifference / size + i;
    }
    totalPixels += size;
  }
  return childrenSizes.length.toDouble();
}
