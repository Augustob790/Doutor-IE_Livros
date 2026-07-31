import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      final ColorScheme colors = Theme.of(dialogContext).colorScheme;
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
        actionsPadding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        icon: Container(
          width: 64,
          height: 64,
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: destructive ? colors.errorContainer : colors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            destructive ? Icons.delete_outline_rounded : Icons.help_outline,
            color: destructive ? colors.onErrorContainer : colors.onPrimaryContainer,
            size: 32,
          ),
        ),
        title: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 500),
          child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56), // Botão mais alto
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(cancelLabel, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 16), // Espaço entre os botões
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56), // Botão mais alto
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: destructive ? colors.error : null,
                    foregroundColor: destructive ? colors.onError : null,
                  ),
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(confirmLabel, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  return result ?? false;
}
