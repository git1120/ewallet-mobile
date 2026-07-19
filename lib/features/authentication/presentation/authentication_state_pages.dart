import 'package:flutter/material.dart';
import 'package:iba_ewallet/app/localization/generated/app_localizations.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';
import 'package:iba_ewallet/design_system/design_system.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_controller.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_state.dart';

class AuthenticationBootstrapPage extends StatelessWidget {
  const AuthenticationBootstrapPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IbaLoadingState(
        label: AppLocalizations.of(context)!.authCheckingSession,
      ),
    ),
  );
}

class AuthenticationTerminalPage extends StatelessWidget {
  const AuthenticationTerminalPage({required this.controller, super.key});

  final AuthenticationController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final restriction = controller.state.restriction;
    final (title, message, icon) = switch (restriction) {
      AccountRestriction.suspended => (
        l10n.authAccountSuspendedTitle,
        l10n.authAccountSuspendedMessage,
        Icons.person_off_outlined,
      ),
      AccountRestriction.lockedOrBlocked => (
        l10n.authAccountLockedTitle,
        l10n.authAccountLockedMessage,
        Icons.lock_outline,
      ),
      AccountRestriction.closed => (
        l10n.authAccountClosedTitle,
        l10n.authAccountClosedMessage,
        Icons.no_accounts_outlined,
      ),
      AccountRestriction.other => (
        l10n.authAccountLockedTitle,
        l10n.authAccountLockedMessage,
        Icons.lock_outline,
      ),
      AccountRestriction.none => (
        controller.state.terminalReason == AuthenticationTerminalReason.expired
            ? l10n.authSessionExpiredTitle
            : l10n.authSessionEndedTitle,
        controller.state.terminalReason == AuthenticationTerminalReason.expired
            ? l10n.authSessionExpiredMessage
            : l10n.authSessionEndedMessage,
        Icons.schedule_outlined,
      ),
    };
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 412),
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
              child: Semantics(
                container: true,
                label: title,
                child: Column(
                  children: [
                    Icon(icon, size: 72, color: IbaColors.error),
                    const SizedBox(height: IbaSpacing.lg),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: IbaSpacing.md),
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: IbaSpacing.xl),
                    IbaButton(
                      label: l10n.authLoginAgain,
                      onPressed: controller.acknowledgeTerminalState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthenticatedPlaceholderPage extends StatelessWidget {
  const AuthenticatedPlaceholderPage({required this.controller, super.key});

  final AuthenticationController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final loggingOut = controller.state.session == SessionStatus.loggingOut;
    return IbaPageScaffold(
      title: l10n.appName,
      body: Padding(
        padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 72,
              color: IbaColors.green,
            ),
            const SizedBox(height: IbaSpacing.lg),
            Text(
              l10n.authSessionActiveTitle,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: IbaSpacing.sm),
            Text(l10n.authSessionActiveMessage, textAlign: TextAlign.center),
            const SizedBox(height: IbaSpacing.xl),
            IbaButton(
              label: loggingOut ? l10n.authLoggingOut : l10n.authLogout,
              loading: loggingOut,
              onPressed: loggingOut ? null : controller.logout,
            ),
          ],
        ),
      ),
    );
  }
}
