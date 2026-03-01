import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
import '../../../domain/entities/daily_log.dart';

class StampCalendar extends StatefulWidget {
  final List<DailyLog> logs;

  const StampCalendar({super.key, required this.logs});

  @override
  State<StampCalendar> createState() => _StampCalendarState();
}

class _StampCalendarState extends State<StampCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final logMap = <String, DailyLog>{};
    for (var log in widget.logs) {
      logMap[_dateKey(log.date)] = log;
    }

    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7; // 0=Sun

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ヘッダー：月ナビゲーション
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
              onPressed: () => setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month - 1);
              }),
            ),
            Text(
              DateFormat('yyyy年 M月').format(_focusedMonth),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onPressed: () => setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month + 1);
              }),
            ),
          ],
        ),
        // 曜日ヘッダー
        Row(
          children: ['日', '月', '火', '水', '木', '金', '土']
              .asMap()
              .entries
              .map((e) => Expanded(
                    child: Center(
                      child: Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: e.key == 0 || e.key == 6
                              ? const Color(0xFFAB47BC)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // カレンダーグリッド
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 4,
            childAspectRatio: 0.85,
          ),
          itemCount: firstWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox.shrink();
            final day = index - firstWeekday + 1;
            final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
            final key = _dateKey(date);
            final log = logMap[key];
            final isToday = _isToday(date);
            return _buildDayCell(day, log, isToday);
          },
        ),
        const SizedBox(height: 12),
        // 凡例
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legend('👑', '両方完了'),
            const SizedBox(width: 12),
            _legend('🌙', '夜のみ'),
            const SizedBox(width: 12),
            _legend('☀️', '朝のみ'),
            const SizedBox(width: 12),
            _legend('・', '記録なし'),
          ],
        ),
      ],
    );
  }

  Widget _buildDayCell(int day, DailyLog? log, bool isToday) {
    final stamp = _getStamp(log);
    final bgColor = isToday
        ? AppColors.accent.withOpacity(0.15)
        : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppColors.accent.withOpacity(0.5))
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: 11,
              color: isToday ? AppColors.accent : AppColors.textSecondary,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stamp,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  String _getStamp(DailyLog? log) {
    if (log == null) return '　';
    if (log.eveningCompleted && log.morningCompleted) return '👑';
    if (log.eveningCompleted) return '🌙';
    if (log.morningCompleted) return '☀️';
    return '・';
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  Widget _legend(String stamp, String label) {
    return Row(
      children: [
        Text(stamp, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}
