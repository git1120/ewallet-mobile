import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';

class IbaPinKeypad extends StatelessWidget {
  const IbaPinKeypad({
    required this.semanticLabel,
    required this.deleteSemanticLabel,
    required this.enteredDigits,
    required this.onDigit,
    required this.onDelete,
    this.enabled = true,
    this.length = 6,
    super.key,
  });

  final String semanticLabel;
  final String deleteSemanticLabel;
  final int enteredDigits;
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final bool enabled;
  final int length;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: semanticLabel,
    obscured: true,
    child: Column(
      children: [
        ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: List.generate(
              length,
              (index) => Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: IbaSpacing.xs,
                ),
                child: AnimatedContainer(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : IbaMotion.fast,
                  width: IbaSpacing.md,
                  height: IbaSpacing.md,
                  decoration: BoxDecoration(
                    color: index < enteredDigits
                        ? IbaColors.green
                        : IbaColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: IbaColors.outline),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: IbaSpacing.xl),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.65,
          mainAxisSpacing: IbaSpacing.xs,
          crossAxisSpacing: IbaSpacing.xs,
          children: [
            for (final digit in const [
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
            ])
              _Key(
                label: digit,
                onPressed: enabled ? () => onDigit(digit) : null,
              ),
            const SizedBox.shrink(),
            _Key(label: '0', onPressed: enabled ? () => onDigit('0') : null),
            _Key(
              label: deleteSemanticLabel,
              icon: Icons.backspace_outlined,
              onPressed: enabled && enteredDigits > 0 ? onDelete : null,
            ),
          ],
        ),
      ],
    ),
  );
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 56),
        backgroundColor: IbaColors.surface,
        foregroundColor: IbaColors.ink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IbaRadii.sm),
        ),
      ),
      child: icon == null
          ? Text(label, style: Theme.of(context).textTheme.titleLarge)
          : Icon(icon, semanticLabel: label),
    ),
  );
}
