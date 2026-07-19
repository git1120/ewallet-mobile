import 'package:flutter/material.dart';
import 'package:iba_ewallet/app/localization/generated/app_localizations.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';
import 'package:iba_ewallet/design_system/design_system.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_controller.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_state.dart';

class AuthenticationLoginPage extends StatefulWidget {
  const AuthenticationLoginPage({required this.controller, super.key});

  final AuthenticationController controller;

  @override
  State<AuthenticationLoginPage> createState() =>
      _AuthenticationLoginPageState();
}

class _AuthenticationLoginPageState extends State<AuthenticationLoginPage>
    with WidgetsBindingObserver {
  final _mobileController = TextEditingController();
  final _mobileFocus = FocusNode();
  String? _mobileError;
  String _pin = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _clearPin();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.cancelLoginAttempt();
    _pin = '';
    _mobileController.dispose();
    _mobileFocus.dispose();
    super.dispose();
  }

  void _advanceToPin() {
    final l10n = AppLocalizations.of(context)!;
    final mobile = _mobileController.text;
    if (mobile.isEmpty) {
      setState(() => _mobileError = l10n.authMobileRequired);
      _mobileFocus.requestFocus();
      return;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      setState(() => _mobileError = l10n.authMobileInvalid);
      _mobileFocus.requestFocus();
      return;
    }
    setState(() => _mobileError = null);
    FocusScope.of(context).unfocus();
    widget.controller.continueToPin();
  }

  void _addDigit(String digit) {
    if (_pin.length >= 6 || widget.controller.state.isSubmitting) return;
    setState(() => _pin += digit);
    if (_pin.length == 6) {
      final submittedPin = _pin;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await widget.controller.login(
          mobileNumber: _mobileController.text,
          pin: submittedPin,
        );
        if (mounted) _clearPin();
      });
    }
  }

  void _deleteDigit() {
    if (_pin.isEmpty || widget.controller.state.isSubmitting) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _clearPin() {
    if (!mounted || _pin.isEmpty) return;
    setState(() => _pin = '');
  }

  void _changeMobile() {
    _clearPin();
    widget.controller.changeMobile();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.controller,
    builder: (context, _) {
      final state = widget.controller.state;
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 412),
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  IbaSpacing.lg,
                  IbaSpacing.md,
                  IbaSpacing.lg,
                  IbaSpacing.lg,
                ),
                child: state.loginStage == LoginStage.mobileEntry
                    ? _mobileEntry(state)
                    : state.loginStage == LoginStage.temporarilyLocked
                    ? _lockedState()
                    : _pinEntry(state),
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget _mobileEntry(AuthenticationState state) {
    final l10n = AppLocalizations.of(context)!;
    final valid = RegExp(r'^\d{10}$').hasMatch(_mobileController.text);
    return Semantics(
      container: true,
      label: l10n.authLoginScreenSemanticLabel,
      child: Column(
        children: [
          const SizedBox(height: IbaSpacing.xl),
          const _SecurityMark(icon: Icons.account_balance_outlined),
          const SizedBox(height: IbaSpacing.lg),
          Text(
            l10n.authLoginScreenTitle,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: IbaSpacing.xs),
          Text(
            l10n.authLoginSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: IbaSpacing.xl),
          IbaPhoneField(
            key: const ValueKey('auth-mobile-field'),
            label: l10n.authMobileLabel,
            controller: _mobileController,
            focusNode: _mobileFocus,
            errorText: _mobileError,
            maxDigits: 10,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _advanceToPin(),
            onChanged: (_) => setState(() {
              if (_mobileError != null) _mobileError = null;
            }),
          ),
          const SizedBox(height: IbaSpacing.lg),
          IbaButton(
            key: const ValueKey('auth-continue'),
            label: l10n.authContinue,
            onPressed: valid ? _advanceToPin : null,
          ),
          const SizedBox(height: IbaSpacing.xxl),
          IbaAlertBanner(
            message: l10n.authPrivacyPinMessage,
            status: IbaStatus.information,
          ),
        ],
      ),
    );
  }

  Widget _pinEntry(AuthenticationState state) {
    final l10n = AppLocalizations.of(context)!;
    final errorMessage = switch ((state.loginStage, state.request)) {
      (LoginStage.invalidCredentials, _) => l10n.authInvalidCredentials,
      (_, AuthenticationRequestStatus.offline) => l10n.authOfflineMessage,
      (_, AuthenticationRequestStatus.serverUnavailable) =>
        l10n.authServerUnavailableMessage,
      _ => null,
    };
    return Semantics(
      container: true,
      label: l10n.authPinScreenTitle,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IbaIconButton(
              icon: Icons.arrow_back,
              semanticLabel: l10n.authChangeMobile,
              onPressed: state.isSubmitting ? null : _changeMobile,
            ),
          ),
          const _SecurityMark(icon: Icons.shield_outlined),
          const SizedBox(height: IbaSpacing.md),
          Text(
            l10n.authPinScreenTitle,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: IbaSpacing.xs),
          Text(l10n.authPinInstruction, textAlign: TextAlign.center),
          const SizedBox(height: IbaSpacing.sm),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              _maskedMobile,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: IbaColors.green),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: IbaSpacing.md),
            IbaAlertBanner(message: errorMessage, status: IbaStatus.error),
          ],
          const SizedBox(height: IbaSpacing.lg),
          IbaPinKeypad(
            key: const ValueKey('auth-pin-keypad'),
            semanticLabel: l10n.authPinFieldLabel,
            deleteSemanticLabel: l10n.authDeletePinDigit,
            enteredDigits: _pin.length,
            enabled: !state.isSubmitting,
            onDigit: _addDigit,
            onDelete: _deleteDigit,
          ),
          const SizedBox(height: IbaSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IbaTextButton(
              label: l10n.authChangeMobile,
              onPressed: state.isSubmitting ? null : _changeMobile,
            ),
          ),
          if (state.isSubmitting) IbaLoadingState(label: l10n.authSigningIn),
        ],
      ),
    );
  }

  Widget _lockedState() {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      container: true,
      label: l10n.authAccountTemporarilyLockedTitle,
      child: Column(
        children: [
          const SizedBox(height: IbaSpacing.xxl),
          const _SecurityMark(icon: Icons.lock_outline, color: IbaColors.error),
          const SizedBox(height: IbaSpacing.lg),
          Text(
            l10n.authAccountTemporarilyLockedTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: IbaColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: IbaSpacing.md),
          Text(
            l10n.authAccountTemporarilyLockedMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: IbaSpacing.xl),
          IbaButton(label: l10n.authLoginAgain, onPressed: _changeMobile),
        ],
      ),
    );
  }

  String get _maskedMobile {
    final value = _mobileController.text;
    if (value.length < 4) return '••••';
    return '••• ••• ${value.substring(value.length - 4)}';
  }
}

class _SecurityMark extends StatelessWidget {
  const _SecurityMark({required this.icon, this.color = IbaColors.green});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: IbaColors.greenSoft,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: IbaSpacing.xl),
    ),
  );
}
