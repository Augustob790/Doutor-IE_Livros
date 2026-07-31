import 'package:flutter/material.dart';

abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double expanded = 900;
  static const double wide = 1200;
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 1180,
    this.compactPadding = 16,
    this.expandedPadding = 32,
    this.verticalPadding = 24,
  });

  final Widget child;
  final double maxWidth;
  final double compactPadding;
  final double expandedPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact = constraints.maxWidth < AppBreakpoints.compact;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? compactPadding : expandedPadding,
                vertical: verticalPadding,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
