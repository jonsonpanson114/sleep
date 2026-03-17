import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/analytics_provider.dart';
import '../../../core/constants.dart';

class SaitoDailyCard extends ConsumerWidget {
  const SaitoDailyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advice = ref.watch(dailyAdviceProvider);
    final analyticsAsync = ref.watch(sleepAnalyticsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.accent,
                child: Text('斎', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    '斎藤さんの独り言',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    advice.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(advice.emoji, style: const TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            advice.content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // 疲れ度アラート
          analyticsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (data) {
              if (data.suggestEarlySleep) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          '疲れが溜まり気味だ。今日は早めに寝るモードに切り替えて、ルーティンは最低限にしようぜ。',
                          style: TextStyle(fontSize: 11, color: AppColors.danger, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: 早寝モードの実装（ルーティンを自動で省略するフラグなど）
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('早寝モードをオンにしました。今夜は無理せず休みましょう。')),
                          );
                        }, 
                        child: const Text('モードON', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
