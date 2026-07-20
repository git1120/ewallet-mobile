import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';

@immutable
class IbaFinancialTheme extends ThemeExtension<IbaFinancialTheme> {
  const IbaFinancialTheme({required this.positive, required this.negative});
  final Color positive;
  final Color negative;

  @override
  IbaFinancialTheme copyWith({Color? positive, Color? negative}) =>
      IbaFinancialTheme(
        positive: positive ?? this.positive,
        negative: negative ?? this.negative,
      );

  @override
  IbaFinancialTheme lerp(IbaFinancialTheme? other, double t) => other == null
      ? this
      : IbaFinancialTheme(
          positive: Color.lerp(positive, other.positive, t)!,
          negative: Color.lerp(negative, other.negative, t)!,
        );
}

abstract final class IbaTheme {
  static ThemeData light({required Locale locale}) {
    final isArabicScript = locale.languageCode != 'en';
    final scheme = ColorScheme.fromSeed(
      seedColor: IbaColors.green,
      brightness: Brightness.light,
      primary: IbaColors.green,
      secondary: IbaColors.gold,
      surface: IbaColors.surface,
      error: IbaColors.error,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: IbaColors.background,
      fontFamily: isArabicScript
          ? IbaTypography.arabicFamily
          : IbaTypography.latinFamily,
    );
    final textTheme = base.textTheme
        .apply(bodyColor: IbaColors.ink, displayColor: IbaColors.ink)
        .copyWith(
          headlineLarge: base.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          titleMedium: base.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(IbaRadii.md),
    );
    return base.copyWith(
      textTheme: textTheme,
      extensions: const [
        IbaFinancialTheme(
          positive: IbaColors.success,
          negative: IbaColors.error,
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: IbaColors.background,
        foregroundColor: IbaColors.ink,
        centerTitle: false,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: shape,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: IbaColors.surface,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: IbaSpacing.md,
          vertical: IbaSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IbaRadii.md),
          borderSide: const BorderSide(color: IbaColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IbaRadii.md),
          borderSide: const BorderSide(color: IbaColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IbaRadii.md),
          borderSide: const BorderSide(color: IbaColors.green, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IbaRadii.md),
          borderSide: const BorderSide(color: IbaColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IbaRadii.md),
          borderSide: const BorderSide(color: IbaColors.error, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: IbaColors.surface,
        elevation: IbaElevation.low,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IbaRadii.lg),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: IbaColors.surface,
        shape: shape,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: IbaColors.surface,
        showDragHandle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: IbaColors.surface,
        indicatorColor: IbaColors.greenSoft,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
    );
  }
}
