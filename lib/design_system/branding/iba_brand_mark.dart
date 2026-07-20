import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iba_ewallet/core/theme/tokens.dart';

enum IbaBrandMarkVariant { standard, white, securityFallback }

class IbaBrandMark extends StatelessWidget {
  const IbaBrandMark({
    this.variant = IbaBrandMarkVariant.standard,
    this.semanticLabel,
    this.decorative = false,
    this.width = 88,
    this.height,
    super.key,
  }) : fallbackIcon = Icons.shield_outlined,
       fallbackColor = IbaColors.green,
       fallbackBackgroundColor = IbaColors.greenSoft,
       assert(decorative || semanticLabel != null);

  const IbaBrandMark.securityFallback({
    this.semanticLabel,
    this.decorative = true,
    this.width = 72,
    this.height,
    this.fallbackIcon = Icons.shield_outlined,
    this.fallbackColor = IbaColors.green,
    this.fallbackBackgroundColor = IbaColors.greenSoft,
    super.key,
  }) : variant = IbaBrandMarkVariant.securityFallback,
       assert(decorative || semanticLabel != null);

  static const standardAsset = 'assets/branding/iba-logo.png';
  static const whiteAsset = 'assets/branding/iba-logo-white.png';

  final IbaBrandMarkVariant variant;
  final String? semanticLabel;
  final bool decorative;
  final double width;
  final double? height;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final Color fallbackBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final mark = switch (variant) {
      IbaBrandMarkVariant.standard => _assetMark(standardAsset),
      IbaBrandMarkVariant.white => _assetMark(whiteAsset),
      IbaBrandMarkVariant.securityFallback => _securityFallback(),
    };

    if (decorative) return ExcludeSemantics(child: mark);
    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(child: mark),
    );
  }

  Widget _assetMark(String asset) {
    final intrinsicAspectRatio = switch (variant) {
      IbaBrandMarkVariant.standard => 1463 / 1447,
      IbaBrandMarkVariant.white => 928 / 926,
      IbaBrandMarkVariant.securityFallback => 1.0,
    };
    return SizedBox(
      width: width,
      height: height ?? width / intrinsicAspectRatio,
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }

  Widget _securityFallback() {
    final availableHeight = height ?? width;
    final size = min(width, availableHeight);
    return SizedBox(
      width: width,
      height: availableHeight,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: fallbackBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: IbaColors.outline),
          ),
          child: Icon(fallbackIcon, color: fallbackColor, size: size * 0.44),
        ),
      ),
    );
  }
}
