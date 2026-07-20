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
    this.showIndicators = true,
    this.showDialLetters = false,
    super.key,
  });

  final String semanticLabel;
  final String deleteSemanticLabel;
  final int enteredDigits;
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final bool enabled;
  final int length;
  final bool showIndicators;
  final bool showDialLetters;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final scaleExpansion = (textScale - 1).clamp(0.0, 1.0);
    final keyHeight = 64 + (24 * scaleExpansion);
    return Semantics(
      container: true,
      label: semanticLabel,
      obscured: true,
      child: Column(
        children: [
          if (showIndicators) ...[
            IbaPinIndicators(enteredDigits: enteredDigits, length: length),
            const SizedBox(height: IbaSpacing.xl),
          ],
          Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                _digitRow(
                  const ['1', '2', '3'],
                  enabled: enabled,
                  onDigit: onDigit,
                  showDialLetters: showDialLetters,
                  keyHeight: keyHeight,
                ),
                const SizedBox(height: IbaSpacing.xs),
                _digitRow(
                  const ['4', '5', '6'],
                  enabled: enabled,
                  onDigit: onDigit,
                  showDialLetters: showDialLetters,
                  keyHeight: keyHeight,
                ),
                const SizedBox(height: IbaSpacing.xs),
                _digitRow(
                  const ['7', '8', '9'],
                  enabled: enabled,
                  onDigit: onDigit,
                  showDialLetters: showDialLetters,
                  keyHeight: keyHeight,
                ),
                const SizedBox(height: IbaSpacing.xs),
                Row(
                  children: [
                    Expanded(child: SizedBox(height: keyHeight)),
                    const SizedBox(width: IbaSpacing.xs),
                    Expanded(
                      child: _Key(
                        label: '0',
                        height: keyHeight,
                        onPressed: enabled ? () => onDigit('0') : null,
                      ),
                    ),
                    const SizedBox(width: IbaSpacing.xs),
                    Expanded(
                      child: _Key(
                        label: deleteSemanticLabel,
                        height: keyHeight,
                        icon: Icons.backspace_outlined,
                        onPressed: enabled && enteredDigits > 0
                            ? onDelete
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _digitRow(
    List<String> digits, {
    required bool enabled,
    required ValueChanged<String> onDigit,
    required bool showDialLetters,
    required double keyHeight,
  }) => Row(
    children: [
      for (var index = 0; index < digits.length; index++) ...[
        if (index > 0) const SizedBox(width: IbaSpacing.xs),
        Expanded(
          child: _Key(
            label: digits[index],
            supportingLabel: showDialLetters
                ? _dialLetters[digits[index]]
                : null,
            height: keyHeight,
            onPressed: enabled ? () => onDigit(digits[index]) : null,
          ),
        ),
      ],
    ],
  );

  static const _dialLetters = {
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
  };
}

class IbaPinIndicators extends StatelessWidget {
  const IbaPinIndicators({
    required this.enteredDigits,
    this.length = 6,
    super.key,
  });

  final int enteredDigits;
  final int length;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
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
  );
}

class _Key extends StatelessWidget {
  const _Key({
    required this.label,
    required this.onPressed,
    required this.height,
    this.icon,
    this.supportingLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final IconData? icon;
  final String? supportingLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: SizedBox(
      height: height,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          minimumSize: Size(48, height),
          backgroundColor: IbaColors.surface,
          foregroundColor: IbaColors.ink,
          elevation: IbaElevation.low,
          side: const BorderSide(color: IbaColors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(IbaRadii.md),
          ),
        ),
        child: icon == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: Theme.of(context).textTheme.titleLarge),
                  if (supportingLabel != null)
                    Text(
                      supportingLabel!,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                ],
              )
            : Icon(icon, semanticLabel: label),
      ),
    ),
  );
}
