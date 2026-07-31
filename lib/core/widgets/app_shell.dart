import 'package:doutor_ie_test/core/widgets/app_brand.dart';
import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.body,
    required this.appTitle,
    this.appSubtitle,
    this.userLabel,
    this.logoutLabel,
    this.onLogout,
    this.onBack,
    this.floatingActionButton,
    this.bottomBar,
  });

  final Widget body;
  final String appTitle;
  final String? appSubtitle;
  final String? userLabel;
  final String? logoutLabel;
  final Future<void> Function()? onLogout;
  final VoidCallback? onBack;
  final Widget? floatingActionButton;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar == null
          ? null
          : Material(
              color: colors.surface,
              elevation: 8,
              shadowColor: colors.shadow.withValues(alpha: 0.12),
              child: SafeArea(top: false, child: bottomBar!),
            ),
      body: Column(
        children: <Widget>[
          Material(
            color: colors.surface,
            elevation: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colors.outlineVariant),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    if (onBack != null) ...<Widget>[
                      IconButton.filledTonal(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: AppBrand(
                        title: appTitle,
                        subtitle: appSubtitle,
                        compact: true,
                      ),
                    ),
                    if (userLabel != null) _buildUserMenu(context, colors),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildUserMenu(BuildContext context, ColorScheme colors) {
    final Widget avatar = CircleAvatar(
      radius: 19,
      backgroundColor: colors.primaryContainer,
      foregroundColor: colors.onPrimaryContainer,
      child: const Icon(Icons.person_rounded, size: 21),
    );
    if (onLogout == null) {
      return Row(
        children: <Widget>[
          if (MediaQuery.sizeOf(context).width >= 600) ...<Widget>[
            Text(userLabel!, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(width: 10),
          ],
          avatar,
        ],
      );
    }
    return PopupMenuButton<String>(
      tooltip: userLabel,
      onSelected: (_) => onLogout!(),
      itemBuilder: (_) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: <Widget>[
              const Icon(Icons.logout_rounded, size: 20),
              const SizedBox(width: 10),
              Text(logoutLabel ?? ''),
            ],
          ),
        ),
      ],
      child: Row(
        children: <Widget>[
          if (MediaQuery.sizeOf(context).width >= 600) ...<Widget>[
            Text(userLabel!, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(width: 10),
          ],
          avatar,
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}
