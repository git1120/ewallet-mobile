import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';
import 'package:iba_ewallet/design_system/buttons/iba_buttons.dart';

abstract final class IbaBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsetsDirectional.only(
        start: IbaSpacing.lg,
        end: IbaSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + IbaSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: IbaSpacing.md),
          child,
        ],
      ),
    ),
  );
}

abstract final class IbaConfirmationDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) => showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        IbaTextButton(
          label: cancelLabel,
          onPressed: () => Navigator.pop(context, false),
        ),
        IbaButton(
          label: confirmLabel,
          expand: false,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );
}
