import 'package:intl/intl.dart';

final class IbaFormatters {
  const IbaFormatters(this.locale);
  final String locale;

  String amount(num value, {String currency = 'AFN'}) => NumberFormat.currency(
    locale: locale,
    name: currency,
    symbol: currency,
    decimalDigits: 2,
  ).format(value);

  String date(DateTime value) => DateFormat.yMMMd(locale).format(value);
  String time(DateTime value) => DateFormat.jm(locale).format(value);

  static String phone(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final normalized = digits.startsWith('93') ? digits.substring(2) : digits;
    final local = normalized.startsWith('0')
        ? normalized.substring(1)
        : normalized;
    if (local.length < 9) return input;
    return '+93 ${local.substring(0, 3)} ${local.substring(3, 6)} '
        '${local.substring(6, 9)}';
  }

  static String maskAccount(String input) {
    final compact = input.replaceAll(' ', '');
    if (compact.length <= 4) return compact;
    return '•••• ${compact.substring(compact.length - 4)}';
  }
}
