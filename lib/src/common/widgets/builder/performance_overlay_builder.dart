import 'package:flutter/material.dart';
import 'package:performance/performance.dart';

class PerformanceOverlayBuilder extends StatelessWidget {
  const PerformanceOverlayBuilder({
    required this.child,
    required this.isPerformanceTrackingEnabled,
    required this.theme,
    super.key,
  });
  final Widget child;
  final bool isPerformanceTrackingEnabled;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: CustomPerformanceOverlay(
          enabled: isPerformanceTrackingEnabled,
          alignment: Alignment.topCenter,
          backgroundColor: theme.colorScheme.surface,
          textColor: theme.colorScheme.onSurface,
          textBackgroundColor: theme.colorScheme.surface.withOpacity(0.5),
          child: child,
        ),
      );
}
