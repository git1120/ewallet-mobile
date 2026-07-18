import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';
import 'package:iba_ewallet/design_system/buttons/iba_buttons.dart';

enum IbaStatus { success, information, warning, error }

extension on IbaStatus {
  Color color(BuildContext context) => switch (this) {
    IbaStatus.success => IbaColors.success,
    IbaStatus.information => IbaColors.information,
    IbaStatus.warning => IbaColors.warning,
    IbaStatus.error => IbaColors.error,
  };

  IconData get icon => switch (this) {
    IbaStatus.success => Icons.check_circle_outline,
    IbaStatus.information => Icons.info_outline,
    IbaStatus.warning => Icons.warning_amber_rounded,
    IbaStatus.error => Icons.error_outline,
  };
}

class IbaAlertBanner extends StatelessWidget {
  const IbaAlertBanner({
    required this.message,
    required this.status,
    super.key,
  });
  final String message;
  final IbaStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);
    return Semantics(
      container: true,
      liveRegion: true,
      label: message,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.all(IbaSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: BorderDirectional(start: BorderSide(color: color, width: 4)),
          borderRadius: BorderRadiusDirectional.circular(IbaRadii.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(status.icon, color: color),
            const SizedBox(width: IbaSpacing.sm),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class IbaStatusBadge extends StatelessWidget {
  const IbaStatusBadge({required this.label, required this.status, super.key});
  final String label;
  final IbaStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);
    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: IbaSpacing.sm,
          vertical: IbaSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadiusDirectional.circular(IbaRadii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: IbaSpacing.md, color: color),
            const SizedBox(width: IbaSpacing.xs),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}

class IbaEmptyState extends StatelessWidget {
  const IbaEmptyState({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => _IbaMessageState(
    icon: Icons.inbox_outlined,
    title: title,
    message: message,
    actionLabel: actionLabel,
    onAction: onAction,
  );
}

class IbaErrorState extends StatelessWidget {
  const IbaErrorState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onRetry,
    super.key,
  });
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _IbaMessageState(
    icon: Icons.cloud_off_outlined,
    title: title,
    message: message,
    actionLabel: actionLabel,
    onAction: onRetry,
  );
}

class _IbaMessageState extends StatelessWidget {
  const _IbaMessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Padding(
      padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: IbaSpacing.xxl, color: IbaColors.muted),
          const SizedBox(height: IbaSpacing.md),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: IbaSpacing.xs),
          Text(message, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: IbaSpacing.md),
            IbaButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
        ],
      ),
    ),
  );
}

class IbaLoadingState extends StatelessWidget {
  const IbaLoadingState({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    label: label,
    child: const Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(IbaSpacing.lg),
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

class IbaSkeleton extends StatefulWidget {
  const IbaSkeleton({
    this.height = IbaSpacing.xxl,
    this.width = double.infinity,
    super.key,
  });
  final double height;
  final double width;

  @override
  State<IbaSkeleton> createState() => _IbaSkeletonState();
}

class _IbaSkeletonState extends State<IbaSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: IbaMotion.slow,
      lowerBound: 0.35,
      upperBound: 0.75,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      return _box(0.55);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => _box(_controller.value),
    );
  }

  Widget _box(double opacity) => ExcludeSemantics(
    child: Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: IbaColors.outline.withValues(alpha: opacity),
        borderRadius: BorderRadiusDirectional.circular(IbaRadii.sm),
      ),
    ),
  );
}
