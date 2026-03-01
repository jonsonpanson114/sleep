import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../domain/use_cases/calculate_sleep_score.dart';

class SleepStatusBanner extends StatelessWidget {
  final SleepScore sleepScore;

  const SleepStatusBanner({super.key, required this.sleepScore});

  @override
  Widget build(BuildContext context) {
    final level = sleepScore.level;
    final score = sleepScore.score;
    final streak = sleepScore.streak;
    final nextLevel = sleepScore.nextLevel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBackground,
            AppColors.primary.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _scoreColor(score).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // 睡眠スコア円グラフ風
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 7,
                  backgroundColor: AppColors.cardBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(_scoreColor(score)),
                  strokeCap: StrokeCap.round,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _scoreColor(score),
                      ),
                    ),
                    const Text(
                      'pts',
                      style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // レベル & ストリーク情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _levelEmoji(level),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      level.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        size: 16, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      '$streak日連続',
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
                if (nextLevel != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '次: ${nextLevel.label} まで',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'あと${sleepScore.pointsToNextLevel}日',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _levelProgress,
                      minHeight: 5,
                      backgroundColor: AppColors.cardBackground,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_scoreColor(score)),
                    ),
                  ),
                ] else
                  const Text(
                    '🏆 最高レベル達成！',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double get _levelProgress {
    final current = sleepScore.level.minStreak;
    final next = sleepScore.nextLevel?.minStreak ?? (current + 1);
    final progress = (sleepScore.streak - current) / (next - current);
    return progress.clamp(0.0, 1.0);
  }

  Color _scoreColor(int score) {
    if (score >= 80) return const Color(0xFF00E676); // green
    if (score >= 60) return const Color(0xFFFFB300); // amber
    if (score >= 40) return const Color(0xFFFF6D00); // orange
    return const Color(0xFFEF5350); // red
  }

  String _levelEmoji(SleepLevel level) {
    switch (level) {
      case SleepLevel.beginner: return '🌱';
      case SleepLevel.novice: return '🌿';
      case SleepLevel.practitioner: return '⭐';
      case SleepLevel.expert: return '🌟';
      case SleepLevel.master: return '💎';
      case SleepLevel.legend: return '👑';
    }
  }
}
