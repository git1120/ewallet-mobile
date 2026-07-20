import 'dart:async';
import 'dart:math';

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
  final _scrollController = ScrollController();
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
    _scrollController.dispose();
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
    _resetScrollPosition();
  }

  void _addDigit(String digit) {
    if (_pin.length >= 6 || widget.controller.state.isSubmitting) return;
    setState(() => _pin += digit);
    if (_pin.length == 6) {
      final submittedPin = _pin;
      unawaited(
        widget.controller.login(
          mobileNumber: _mobileController.text,
          pin: submittedPin,
        ),
      );
      _clearPin();
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
    _resetScrollPosition();
  }

  void _resetScrollPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
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
              child: _measuredScrollView(
                state.loginStage == LoginStage.mobileEntry
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

  Widget _measuredScrollView(Widget child) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsetsDirectional.all(IbaSpacing.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: max(0, constraints.maxHeight - (IbaSpacing.md * 2)),
        ),
        child: IntrinsicHeight(child: child),
      ),
    ),
  );

  Widget _mobileEntry(AuthenticationState state) {
    final l10n = AppLocalizations.of(context)!;
    final valid = RegExp(r'^\d{10}$').hasMatch(_mobileController.text);
    return Semantics(
      container: true,
      label: l10n.authLoginScreenSemanticLabel,
      child: Column(
        children: [
          const SizedBox(height: 128),
          IbaBrandMark(
            key: const ValueKey('auth-primary-brand-mark'),
            semanticLabel: l10n.appName,
            width: 88,
          ),
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
          const SizedBox(height: 40),
          IbaPhoneField(
            key: const ValueKey('auth-mobile-field'),
            label: l10n.authMobileLabel,
            controller: _mobileController,
            focusNode: _mobileFocus,
            errorText: _mobileError,
            maxDigits: 10,
            textInputAction: TextInputAction.done,
            externalLabel: true,
            countryIndicator: const Icon(
              Icons.flag_outlined,
              color: IbaColors.green,
              size: 20,
            ),
            onSubmitted: (_) => _advanceToPin(),
            onChanged: (_) => setState(() {
              if (_mobileError != null) _mobileError = null;
            }),
          ),
          const SizedBox(height: IbaSpacing.xl),
          IbaButton(
            key: const ValueKey('auth-continue'),
            label: l10n.authContinue,
            onPressed: valid ? _advanceToPin : null,
          ),
          const Spacer(),
          IbaAlertBanner(
            message: l10n.authPrivacyPinMessage,
            status: IbaStatus.security,
          ),
          const SizedBox(height: IbaSpacing.xxl),
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
          const SizedBox(height: 40),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IbaIconButton(
              icon: _backIcon,
              semanticLabel: l10n.authChangeMobile,
              onPressed: state.isSubmitting ? null : _changeMobile,
            ),
          ),
          const IbaBrandMark.securityFallback(
            key: ValueKey('auth-security-mark'),
            width: 56,
          ),
          const SizedBox(height: IbaSpacing.xl),
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
          const SizedBox(height: 44),
          IbaPinIndicators(enteredDigits: _pin.length),
          const SizedBox(height: IbaSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IbaTextButton(
                    label: l10n.authChangeMobile,
                    onPressed: state.isSubmitting ? null : _changeMobile,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: state.isSubmitting
                      ? IbaLoadingState(label: l10n.authSigningIn, inline: true)
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          IbaPinKeypad(
            key: const ValueKey('auth-pin-keypad'),
            semanticLabel: l10n.authPinFieldLabel,
            deleteSemanticLabel: l10n.authDeletePinDigit,
            enteredDigits: _pin.length,
            enabled: !state.isSubmitting,
            showIndicators: false,
            showDialLetters: true,
            onDigit: _addDigit,
            onDelete: _deleteDigit,
          ),
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
          const IbaBrandMark.securityFallback(
            fallbackIcon: Icons.lock_outline,
            fallbackColor: IbaColors.error,
          ),
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
    if (value.length < 4) return '+93 ••••';
    return '+93 •• ••• ${value.substring(value.length - 4)}';
  }

  IconData get _backIcon => Directionality.of(context) == TextDirection.rtl
      ? Icons.arrow_forward
      : Icons.arrow_back;
}
