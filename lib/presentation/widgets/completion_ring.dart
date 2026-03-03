import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class CompletionRing extends StatelessWidget {
  final int completed;
  final int total;
  final double size;

  const CompletionRing({
    super.key,
    required this.completed,
    required this.total,
    this.size = 100,
  });

  double get _percentage => total == 0 ? 0.0 : completed / total;
  double get _progressValue => _percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: _progressValue,
            strokeWidth: size * 0.08, // Scale stroke width with size
            backgroundColor: AppColors.cardBackground,
            valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
          ),
          Center(
            child: Text(
              '$completed/$total',
              style: TextStyle(
                fontSize: size * 0.24, // Scale font size with size
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    if (_percentage >= 1.0) return AppColors.success;
    if (_percentage >= 0.67) return AppColors.accent;
    return AppColors.textSecondary;
  }
}
