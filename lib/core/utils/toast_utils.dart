import 'package:flutter/material.dart';

class ToastUtils {
  static void show(BuildContext context, String message,
      {bool isError = false}) {
    final overlayState = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        final ColorScheme colors = Theme.of(context).colorScheme;
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isError ? colors.error : colors.inverseSurface,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                            color: isError
                                ? colors.onError
                                : colors.onInverseSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }
}
