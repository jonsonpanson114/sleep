import 'package:flutter/material.dart';
import '../../../domain/entities/achievement.dart';
import '../../../core/constants.dart';

class BadgeTile extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const BadgeTile({
    super.key,
    required this.achievement,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isUnlocked ? AppColors.badgeUnlocked : AppColors.badgeLocked;

    return Card(
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              achievement.emoji,
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (achievement.progress > 0 && !isUnlocked)
              const SizedBox(height: 8)
            else if (isUnlocked)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.badgeUnlocked.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '達成！',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
