import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/use_cases/generate_weekly_missions.dart';

class MissionCard extends StatelessWidget {
  final WeeklyMission mission;

  const MissionCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final difficultyColor = _difficultyColor(mission.difficulty);
    final difficultyLabel = _difficultyLabel(mission.difficulty);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        color: mission.isCompleted
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: mission.isCompleted
                ? AppColors.success.withValues(alpha: 0.4)
                : difficultyColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(mission.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mission.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (mission.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('完了！',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: difficultyColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        difficultyLabel,
                        style: TextStyle(
                          fontSize: 11,
                          color: difficultyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // プログレスバー
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: mission.progress,
                        minHeight: 8,
                        backgroundColor: AppColors.cardBackground.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          mission.isCompleted ? AppColors.success : difficultyColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${mission.currentDays}/${mission.targetDays}日',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: mission.isCompleted
                          ? AppColors.success
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _difficultyColor(MissionDifficulty d) {
    switch (d) {
      case MissionDifficulty.easy: return const Color(0xFF42A5F5);
      case MissionDifficulty.medium: return const Color(0xFFFFB300);
      case MissionDifficulty.hard: return const Color(0xFFEF5350);
    }
  }

  String _difficultyLabel(MissionDifficulty d) {
    switch (d) {
      case MissionDifficulty.easy: return '★ EASY';
      case MissionDifficulty.medium: return '★★ NORMAL';
      case MissionDifficulty.hard: return '★★★ HARD';
    }
  }
}
