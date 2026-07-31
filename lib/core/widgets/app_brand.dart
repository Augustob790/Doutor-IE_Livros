import 'package:flutter/material.dart';

class AppBrand extends StatelessWidget {
  const AppBrand({
    super.key,
    required this.title,
    this.subtitle,
    this.compact = false,
    this.centered = false,
  });

  final String title;
  final String? subtitle;
  final bool compact;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Widget mark = Container(
      width: compact ? 38 : 56,
      height: compact ? 38 : 56,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(compact ? 12 : 17),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_stories_rounded,
        color: colors.onPrimary,
        size: compact ? 21 : 30,
        semanticLabel: title,
      ),
    );

    final Widget labels = Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: (compact ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleLarge)
              ?.copyWith(color: colors.onSurface),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...<Widget>[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );

    if (centered) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[mark, const SizedBox(height: 14), labels],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        mark,
        const SizedBox(width: 12),
        Flexible(child: labels),
      ],
    );
  }
}
