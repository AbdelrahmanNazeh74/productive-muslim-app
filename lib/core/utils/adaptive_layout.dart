import 'package:flutter/material.dart';

import 'responsive.dart';

// ─── TWO-COLUMN LAYOUT ────────────────────────────────────────────────────────
/// Renders a two-column layout on tablets, a single column on phones.
///
/// Example:
///   TwoColumnLayout(
///     leftFlex: 2,
///     rightFlex: 3,
///     left: SidebarWidget(),
///     right: ContentWidget(),
///   )
class TwoColumnLayout extends StatelessWidget {
  final Widget left;
  final Widget right;

  /// Width share of the left column (default 2 → 2/5 of the row).
  final int leftFlex;

  /// Width share of the right column (default 3 → 3/5 of the row).
  final int rightFlex;

  final Color? dividerColor;
  final Widget? phoneLayout;

  const TwoColumnLayout({
    super.key,
    required this.left,
    required this.right,
    this.leftFlex = 2,
    this.rightFlex = 3,
    this.dividerColor,
    this.phoneLayout,
  });

  @override
  Widget build(BuildContext context) {
    if (!context.isTablet) {
      return phoneLayout ?? right;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: leftFlex,
          child: left,
        ),
        VerticalDivider(
          width: 1,
          color: dividerColor ??
              Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
        Flexible(
          flex: rightFlex,
          child: right,
        ),
      ],
    );
  }
}

// ─── MAX-WIDTH BOX ────────────────────────────────────────────────────────────
/// Constrains its child to [maxWidth] and centres it horizontally.
/// Useful on tablets where content should not stretch wall-to-wall.
class MaxWidthBox extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const MaxWidthBox({
    super.key,
    this.maxWidth = 720,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget result = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );
    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }
    return Align(alignment: Alignment.topCenter, child: result);
  }
}

// ─── SAFE SCROLL VIEW ────────────────────────────────────────────────────────
/// A [SingleChildScrollView] that automatically adds bottom padding
/// equal to the keyboard height so content is never obscured.
class SafeScrollView extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  const SafeScrollView({
    super.key,
    required this.child,
    this.padding,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final basePadding = padding ?? EdgeInsets.zero;
    final effectivePadding = basePadding is EdgeInsets
        ? basePadding.copyWith(bottom: basePadding.bottom + bottom)
        : EdgeInsets.only(bottom: bottom);

    return SingleChildScrollView(
      controller: controller,
      padding: effectivePadding,
      child: child,
    );
  }
}

// ─── TABLET MASTER-DETAIL ────────────────────────────────────────────────────
/// Master-detail pattern for tablets: renders [master] on the left and
/// [detail] on the right. On phones shows only [master] (the caller
/// handles navigation via push).
class MasterDetailLayout extends StatelessWidget {
  final Widget master;
  final Widget detail;
  final int masterFlex;
  final int detailFlex;
  final Color? backgroundColor;

  const MasterDetailLayout({
    super.key,
    required this.master,
    required this.detail,
    this.masterFlex = 2,
    this.detailFlex = 3,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!context.isTablet) return master;

    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: Row(
        children: [
          Flexible(
            flex: masterFlex,
            child: master,
          ),
          VerticalDivider(
            width: 1,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
          ),
          Flexible(
            flex: detailFlex,
            child: detail,
          ),
        ],
      ),
    );
  }
}
