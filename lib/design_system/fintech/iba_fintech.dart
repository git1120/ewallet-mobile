import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';

class IbaAccountCard extends StatelessWidget {
  const IbaAccountCard({
    required this.name,
    required this.maskedNumber,
    required this.balance,
    required this.currency,
    this.onTap,
    super.key,
  });
  final String name;
  final String maskedNumber;
  final String balance;
  final String currency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: '$name, $maskedNumber, $balance $currency',
    child: Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(IbaRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined),
                  const SizedBox(width: IbaSpacing.sm),
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: IbaSpacing.lg),
              Text(maskedNumber),
              const SizedBox(height: IbaSpacing.xs),
              Text(
                '$balance $currency',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class IbaBalanceCard extends StatelessWidget {
  const IbaBalanceCard({
    required this.label,
    required this.balance,
    required this.currency,
    super.key,
  });
  final String label;
  final String balance;
  final String currency;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [IbaColors.green, IbaColors.greenStrong],
      ),
      borderRadius: BorderRadiusDirectional.circular(IbaRadii.lg),
    ),
    child: DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: IbaSpacing.sm),
          Text(
            '$balance $currency',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class IbaTransactionSummary extends StatelessWidget {
  const IbaTransactionSummary({
    required this.title,
    required this.rows,
    required this.totalLabel,
    required this.total,
    super.key,
  });
  final String title;
  final Map<String, String> rows;
  final String totalLabel;
  final String total;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(IbaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: IbaSpacing.md),
            for (final entry in rows.entries)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: IbaSpacing.sm,
                ),
                child: _SummaryRow(label: entry.key, value: entry.value),
              ),
            const Divider(),
            _SummaryRow(label: totalLabel, value: total, emphasized: true),
          ],
        ),
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        const SizedBox(width: IbaSpacing.md),
        Text(value, style: style, textDirection: TextDirection.ltr),
      ],
    );
  }
}
