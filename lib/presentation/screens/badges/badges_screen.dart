import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/badges_provider.dart';
import '../../widgets/badge_tile.dart';
import '../../../core/constants.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAchievementsAsync = ref.watch(badgesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('バッジ'),
      ),
      body: allAchievementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('エラー: $err')),
        data: (achievements) {
          if (achievements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  const Icon(Icons.military_tech, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  const Text(
                    'まだバッジを解除していません',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ルーティンを達成していくと、\n'
                    '新しいバッジが解除されます！',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // 解除済みと未解除でグループ化
          final unlocked = achievements.where((a) => a.progress >= a.goal).toList();
          final locked = achievements.where((a) => a.progress < a.goal).toList();

          return Column(
            children: [
              // 解除済み
              if (unlocked.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  '解除済み',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: unlocked.map((achievement) => BadgeTile(achievement: achievement, isUnlocked: true)).toList(),
                ),
                const SizedBox(height: 32),
              ],
              // 未解除
              if (locked.isNotEmpty) ...[
                Divider(height: 1, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                const Text(
                  '未解除',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: locked.map((achievement) => BadgeTile(achievement: achievement, isUnlocked: false)).toList(),
                ),
                const SizedBox(height: 32),
              ],
            ],
          );
        },
      ),
    );
  }
}
