import 'package:flutter/material.dart';
import '../../../core/constants.dart';

/// 日中コンディション記録トグル
class ConditionToggle extends StatefulWidget {
  final String label;
  final String emoji;
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final bool answered; // 回答済みかどうか

  const ConditionToggle({
    super.key,
    required this.label,
    required this.emoji,
    required this.value,
    required this.onChanged,
    required this.answered,
  });

  @override
  State<ConditionToggle> createState() => _ConditionToggleState();
}

class _ConditionToggleState extends State<ConditionToggle> {
  bool? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  void _select(bool value) {
    setState(() {
      _selectedValue = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _selectedValue != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.emoji}  ${widget.label}',
            style: TextStyle(
              color: hasValue
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withOpacity(0.5),
              ),
          ),
          Row(
            children: [
              _toggleButton('はい', true),
              const SizedBox(width: 16),
              _toggleButton('いいえ', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool value) {
    final isSelected = _selectedValue == value;
    return GestureDetector(
      onTap: () => _select(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.textSecondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
