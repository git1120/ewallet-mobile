import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';

class IbaTextField extends StatelessWidget {
  const IbaTextField({
    required this.label,
    this.controller,
    this.hint,
    this.errorText,
    this.helperText,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.textDirection,
    this.focusNode,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final FocusNode? focusNode;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    textField: true,
    label: semanticLabel ?? label,
    readOnly: readOnly,
    enabled: enabled,
    child: TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      textDirection: textDirection,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        helperText: helperText,
      ),
    ),
  );
}

class IbaPhoneField extends StatelessWidget {
  const IbaPhoneField({
    required this.label,
    this.controller,
    this.errorText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
    this.maxDigits = 12,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int maxDigits;

  @override
  Widget build(BuildContext context) => IbaTextField(
    label: label,
    controller: controller,
    errorText: errorText,
    enabled: enabled,
    keyboardType: TextInputType.phone,
    inputFormatters: [AfghanPhoneInputFormatter(maxDigits: maxDigits)],
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    textInputAction: textInputAction,
    textDirection: TextDirection.ltr,
    focusNode: focusNode,
  );
}

class AfghanPhoneInputFormatter extends TextInputFormatter {
  AfghanPhoneInputFormatter({this.maxDigits = 12});

  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > maxDigits
        ? digits.substring(0, maxDigits)
        : digits;
    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}

class IbaAmountField extends StatelessWidget {
  const IbaAmountField({
    required this.label,
    this.controller,
    this.currency = 'AFN',
    this.errorText,
    this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String currency;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => IbaTextField(
    label: label,
    controller: controller,
    errorText: errorText,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,12}([.]\d{0,2})?')),
    ],
    onChanged: onChanged,
    semanticLabel: '$label $currency',
  );
}

class IbaPinField extends StatefulWidget {
  const IbaPinField({
    required this.label,
    this.controller,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<IbaPinField> createState() => _IbaPinFieldState();
}

class _IbaPinFieldState extends State<IbaPinField> {
  var _obscured = true;

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.label,
    textField: true,
    obscured: _obscured,
    child: TextField(
      controller: widget.controller,
      obscureText: _obscured,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        counterText: '',
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscured = !_obscured),
          icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    ),
  );
}

class IbaOtpInput extends StatefulWidget {
  const IbaOtpInput({
    required this.label,
    this.length = 6,
    this.onCompleted,
    super.key,
  });

  final String label;
  final int length;
  final ValueChanged<String>? onCompleted;

  @override
  State<IbaOtpInput> createState() => _IbaOtpInputState();
}

class _IbaOtpInputState extends State<IbaOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _changed(int index, String value) {
    if (value.isNotEmpty && index + 1 < widget.length) {
      _nodes[index + 1].requestFocus();
    }
    final code = _controllers.map((item) => item.text).join();
    if (code.length == widget.length) widget.onCompleted?.call(code);
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.label,
    textField: true,
    child: Row(
      textDirection: TextDirection.ltr,
      children: List.generate(
        widget.length,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: index == widget.length - 1 ? 0 : IbaSpacing.xs,
            ),
            child: TextField(
              key: ValueKey('otp-$index'),
              controller: _controllers[index],
              focusNode: _nodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => _changed(index, value),
              decoration: const InputDecoration(counterText: ''),
            ),
          ),
        ),
      ),
    ),
  );
}
