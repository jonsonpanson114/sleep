import 'package:flutter/material.dart';
import '../../../core/constants.dart';

/// おやすみモード背景 - タスク完了率に応じて暗くなる
class NightSkyBackground extends StatelessWidget {
  final double completionRatio; // 0.0 ~ 1.0
  final Widget? child;

  const NightSkyBackground({
    super.key,
    required this.completionRatio,
    this.child,
  });

  Color get _backgroundColor {
    // 完了率に応じて4段階の背景色
    if (completionRatio >= 1.0) return AppColors.nightModeBackgrounds[3];
    if (completionRatio >= 0.67) return AppColors.nightModeBackgrounds[2];
    if (completionRatio >= 0.33) return AppColors.nightModeBackgrounds[1];
    return AppColors.nightModeBackgrounds[0];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: _backgroundColor,
      child: child,
    );
  }
}
