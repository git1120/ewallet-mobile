import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';

class IbaButton extends StatelessWidget {
  const IbaButton({
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.loading = false,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = Semantics(
      button: true,
      label: label,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : IbaMotion.fast,
          child: loading
              ? const SizedBox.square(
                  key: ValueKey('loading'),
                  dimension: IbaSpacing.lg,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  key: const ValueKey('content'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon, size: IbaSpacing.lg),
                      const SizedBox(width: IbaSpacing.xs),
                    ],
                    Flexible(child: Text(label)),
                  ],
                ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class IbaIconButton extends StatelessWidget {
  const IbaIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: semanticLabel,
    onPressed: loading ? null : onPressed,
    icon: loading
        ? const SizedBox.square(
            dimension: IbaSpacing.lg,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon, semanticLabel: semanticLabel),
  );
}

class IbaTextButton extends StatelessWidget {
  const IbaTextButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: onPressed, child: Text(label));
}
