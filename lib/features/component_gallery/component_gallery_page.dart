import 'package:flutter/material.dart';
import 'package:iba_ewallet/app/localization/generated/app_localizations.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';
import 'package:iba_ewallet/core/utils/formatters.dart';
import 'package:iba_ewallet/design_system/design_system.dart';

class ComponentGalleryPage extends StatelessWidget {
  const ComponentGalleryPage({
    required this.locale,
    required this.largeText,
    required this.onLocaleChanged,
    required this.onLargeTextChanged,
    super.key,
  });

  final Locale locale;
  final bool largeText;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<bool> onLargeTextChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final format = IbaFormatters(locale.languageCode);
    return IbaPageScaffold(
      title: l10n.galleryTitle,
      body: ListView(
        padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
        children: [
          _GalleryControls(
            locale: locale,
            largeText: largeText,
            onLocaleChanged: onLocaleChanged,
            onLargeTextChanged: onLargeTextChanged,
          ),
          _Section(
            title: l10n.branding,
            children: [
              Wrap(
                spacing: IbaSpacing.lg,
                runSpacing: IbaSpacing.lg,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IbaBrandMark(semanticLabel: l10n.appName),
                  IbaBrandMark(semanticLabel: l10n.appName, width: 56),
                  const IbaBrandMark(width: 56, decorative: true),
                  const IbaBrandMark.securityFallback(width: 56),
                ],
              ),
              Container(
                padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
                color: IbaColors.green,
                alignment: Alignment.center,
                child: IbaBrandMark(
                  variant: IbaBrandMarkVariant.white,
                  semanticLabel: l10n.appName,
                ),
              ),
            ],
          ),
          _Section(
            title: l10n.buttons,
            children: [
              IbaButton(
                label: l10n.continueLabel,
                leadingIcon: Icons.arrow_forward,
                onPressed: () {},
              ),
              IbaButton(label: l10n.loading, loading: true, onPressed: () {}),
              IbaButton(label: l10n.disabled, onPressed: null),
              Wrap(
                spacing: IbaSpacing.xs,
                children: [
                  IbaIconButton(
                    icon: Icons.notifications_outlined,
                    semanticLabel: l10n.informationMessage,
                    onPressed: () {},
                  ),
                  IbaTextButton(label: l10n.secondaryAction, onPressed: () {}),
                ],
              ),
            ],
          ),
          _Section(
            title: l10n.inputs,
            children: [
              IbaTextField(label: l10n.optionalNote),
              IbaTextField(label: l10n.readOnly, readOnly: true),
              IbaTextField(
                label: l10n.errorMessage,
                errorText: l10n.errorMessage,
              ),
              IbaPhoneField(label: l10n.phoneNumber),
              IbaPhoneField(
                label: l10n.phoneNumber,
                externalLabel: true,
                countryIndicator: const Icon(
                  Icons.flag_outlined,
                  color: IbaColors.green,
                  size: 20,
                ),
              ),
              IbaPhoneField(
                label: l10n.phoneNumber,
                errorText: l10n.errorMessage,
                externalLabel: true,
              ),
              IbaPhoneField(
                label: l10n.phoneNumber,
                enabled: false,
                externalLabel: true,
              ),
              IbaAmountField(label: l10n.amount),
              IbaPinField(label: l10n.pin),
              const IbaPinIndicators(enteredDigits: 3),
              IbaPinKeypad(
                semanticLabel: l10n.pin,
                deleteSemanticLabel: l10n.authDeletePinDigit,
                enteredDigits: 3,
                showDialLetters: true,
                onDigit: (_) {},
                onDelete: () {},
              ),
              IbaPinKeypad(
                semanticLabel: l10n.pin,
                deleteSemanticLabel: l10n.authDeletePinDigit,
                enteredDigits: 0,
                enabled: false,
                onDigit: (_) {},
                onDelete: () {},
              ),
              IbaOtpInput(label: l10n.otp),
            ],
          ),
          _Section(
            title: l10n.feedback,
            children: [
              IbaAlertBanner(
                message: l10n.successMessage,
                status: IbaStatus.success,
              ),
              IbaAlertBanner(
                message: l10n.informationMessage,
                status: IbaStatus.information,
              ),
              IbaAlertBanner(
                message: l10n.warningMessage,
                status: IbaStatus.warning,
              ),
              IbaAlertBanner(
                message: l10n.errorMessage,
                status: IbaStatus.error,
              ),
              IbaStatusBadge(
                label: l10n.statusActive,
                status: IbaStatus.success,
              ),
              IbaEmptyState(title: l10n.emptyTitle, message: l10n.emptyMessage),
              IbaErrorState(
                title: l10n.errorMessage,
                message: l10n.informationMessage,
                actionLabel: l10n.tryAgain,
                onRetry: () {},
              ),
              IbaLoadingState(label: l10n.loading),
              const IbaSkeleton(),
            ],
          ),
          _Section(
            title: l10n.financial,
            children: [
              IbaBalanceCard(
                label: l10n.availableBalance,
                balance: format.amount(24850, currency: 'AFN'),
                currency: '',
              ),
              IbaAccountCard(
                name: l10n.account,
                maskedNumber: IbaFormatters.maskAccount('9876543210987654'),
                balance: format.amount(24850, currency: 'AFN'),
                currency: '',
                onTap: () {},
              ),
              IbaTransactionSummary(
                title: l10n.transaction,
                rows: {
                  l10n.amount: format.amount(1000, currency: 'AFN'),
                  l10n.fee: format.amount(20, currency: 'AFN'),
                },
                totalLabel: l10n.total,
                total: format.amount(1020, currency: 'AFN'),
              ),
              IbaButton(
                label: l10n.showSheet,
                onPressed: () => IbaBottomSheet.show<void>(
                  context: context,
                  title: l10n.confirmationTitle,
                  child: IbaButton(
                    label: l10n.close,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              IbaButton(
                label: l10n.confirmationTitle,
                onPressed: () => IbaConfirmationDialog.show(
                  context: context,
                  title: l10n.confirmationTitle,
                  message: l10n.confirmationMessage,
                  confirmLabel: l10n.confirm,
                  cancelLabel: l10n.cancel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GalleryControls extends StatelessWidget {
  const _GalleryControls({
    required this.locale,
    required this.largeText,
    required this.onLocaleChanged,
    required this.onLargeTextChanged,
  });
  final Locale locale;
  final bool largeText;
  final ValueChanged<Locale> onLocaleChanged;
  final ValueChanged<bool> onLargeTextChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      runSpacing: IbaSpacing.sm,
      spacing: IbaSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(l10n.language),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
            ButtonSegment(value: 'fa', label: Text(l10n.languageDari)),
            ButtonSegment(value: 'ps', label: Text(l10n.languagePashto)),
          ],
          selected: {locale.languageCode},
          onSelectionChanged: (value) => onLocaleChanged(Locale(value.single)),
        ),
        Text(l10n.textSize),
        Switch(value: largeText, onChanged: onLargeTextChanged),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(top: IbaSpacing.xl),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: IbaSpacing.md),
        for (final child in children) ...[
          child,
          const SizedBox(height: IbaSpacing.md),
        ],
      ],
    ),
  );
}
