import 'package:feedback_plus/feedback_plus.dart';
import 'package:flutter/material.dart';
import 'package:ispect/ispect.dart';
import 'package:ispect/src/common/extensions/context.dart';
import 'package:ispect/src/common/utils/adjust_color.dart';
import 'package:ispect/src/common/widgets/builder/performance_overlay_builder.dart';
import 'package:ispect/src/common/widgets/feedback_body.dart';
import 'package:ispect/src/features/inspector/inspector.dart';
import 'package:provider/provider.dart';

class ISpectBuilder extends StatelessWidget {
  const ISpectBuilder({
    required this.child,
    this.initialPosition,
    this.navigatorKey,
    this.feedbackTheme,
    this.feedBackDarkTheme,
    this.feedbackBuilder,
    this.onPositionChanged,
    super.key,
  });
  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? child;
  final FeedbackThemeData? feedbackTheme;
  final FeedbackThemeData? feedBackDarkTheme;
  final Widget Function(
    BuildContext context,
    Future<void> Function(String text, {Map<String, dynamic>? extras}) onSubmit,
    ScrollController? controller,
  )? feedbackBuilder;
  final void Function(double x, double y)? onPositionChanged;
  final (double x, double y)? initialPosition;

  @override
  Widget build(BuildContext context) {
    final ispectModel = ISpect.watch(context);

    final theme = Theme.of(context);
    return Consumer<ISpectScopeModel>(
      builder: (
        context,
        _,
        child,
      ) {
        /// Add inspector to the widget tree
        child = Inspector(
          options: ispectModel.options,
          navigatorKey: navigatorKey,
          isPanelVisible: ispectModel.isISpectEnabled,
          backgroundColor:
              adjustColorBrightness(theme.colorScheme.primaryContainer, 0.6),
          selectedColor: theme.colorScheme.primaryContainer,
          textColor: theme.colorScheme.onSurface,
          selectedTextColor: theme.colorScheme.onSurface,
          onPositionChanged: onPositionChanged,
          initialPosition: initialPosition,
          child: child ?? const SizedBox(),
        );

        /// Add performance overlay to the widget tree
        child = PerformanceOverlayBuilder(
          isPerformanceTrackingEnabled:
              ispectModel.isPerformanceTrackingEnabled,
          theme: theme,
          child: child,
        );

        /// Add feedback button to the widget tree
        child = BetterFeedback(
          themeMode: context.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: ISpectLocalization.localizationDelegates,
          localeOverride: ispectModel.options.locale,
          theme: feedbackTheme ??
              FeedbackThemeData(
                background: Colors.grey[800]!,
                feedbackSheetColor: context.ispectTheme.colorScheme.surface,
                activeFeedbackModeColor:
                    context.ispectTheme.colorScheme.primary,
                cardColor: context.ispectTheme.scaffoldBackgroundColor,
                bottomSheetDescriptionStyle:
                    context.ispectTheme.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[800],
                ),
                dragHandleColor: Colors.grey[400],
                inactiveColor: Colors.grey[700]!,
                textColor: Colors.grey[800]!,
              ),
          darkTheme: feedBackDarkTheme ??
              FeedbackThemeData(
                background: Colors.grey[800]!,
                feedbackSheetColor: context.ispectTheme.colorScheme.surface,
                activeFeedbackModeColor:
                    context.ispectTheme.colorScheme.primary,
                cardColor: context.ispectTheme.scaffoldBackgroundColor,
                bottomSheetDescriptionStyle:
                    context.ispectTheme.textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[300],
                ),
                dragHandleColor: Colors.grey[400],
                inactiveColor: Colors.grey[600]!,
                textColor: Colors.grey[300]!,
              ),
          mode: FeedbackMode.navigate,
          feedbackBuilder: feedbackBuilder ??
              (_, extras, scrollController) => SimpleFeedbackBuilder(
                    onSubmit: extras,
                    scrollController: scrollController,
                    theme: theme,
                  ),
          child: child,
        );

        return child;
      },
      child: child,
    );
  }
}
