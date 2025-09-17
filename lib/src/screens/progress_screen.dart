import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../models/test_model.dart';
import '../models/achievement_model.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testResults = ref.watch(testResultsProvider);
    final achievements = ref.watch(achievementsProvider);
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Progress'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview stats
            _buildOverviewStats(unlockedAchievements, testResults.length),
            
            const SizedBox(height: 24),
            
            // Progress chart
            _buildProgressChart(testResults),
            
            const SizedBox(height: 24),
            
            // Recent tests
            _buildRecentTests(testResults),
            
            const SizedBox(height: 24),
            
            // Achievements preview
            _buildAchievementsPreview(achievements),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats(int achievements, int testsCompleted) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Tests Completed',
            testsCompleted.toString(),
            Icons.check_circle,
            AppTheme.successColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Achievements',
            achievements.toString(),
            Icons.emoji_events,
            AppColors.warning,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Streak',
            '7 days',
            Icons.local_fire_department,
            AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(List<TestResult> testResults) {
    // Group results by test type
    final groupedResults = <TestType, List<TestResult>>{};
    for (final result in testResults) {
      groupedResults.putIfAbsent(result.testType, () => []).add(result);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Trends',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 20),
          
          // Chart
          SizedBox(
            height: 200,
            child: groupedResults.isEmpty
                ? _buildEmptyChart()
                : _buildLineChart(groupedResults),
          ),
          
          const SizedBox(height: 16),
          
          // Legend
          _buildChartLegend(),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            'No test data yet',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete some tests to see your progress',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(Map<TestType, List<TestResult>> groupedResults) {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.accentColor,
      AppColors.warning,
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200]!,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey[200]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  'Test ${value.toInt()}',
                  style: AppTextStyles.bodySmall,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.bodySmall,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[300]!),
        ),
        minX: 0,
        maxX: 10,
        minY: 0,
        maxY: 10,
        lineBarsData: groupedResults.entries.take(4).map((entry) {
          final testType = entry.key;
          final results = entry.value;
          final colorIndex = testType.index % colors.length;
          
          return LineChartBarData(
            spots: results.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.score / 10);
            }).toList(),
            isCurved: true,
            color: colors[colorIndex],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: colors[colorIndex],
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: colors[colorIndex].withOpacity(0.1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartLegend() {
    final testTypes = TestType.values.take(4);
    final colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.accentColor,
      AppColors.warning,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: testTypes.map((type) {
        final colorIndex = type.index % colors.length;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[colorIndex],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _getTestDisplayName(type),
              style: AppTextStyles.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRecentTests(List<TestResult> testResults) {
    final recentTests = testResults.take(5).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Tests',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 16),
          
          if (recentTests.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No tests completed yet',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...recentTests.map((test) => _buildTestItem(test)),
        ],
      ),
    );
  }

  Widget _buildTestItem(TestResult test) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getTestColor(test.testType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTestIcon(test.testType),
              color: _getTestColor(test.testType),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTestDisplayName(test.testType),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${test.score.toStringAsFixed(1)} ${test.unit}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(test.completedAt),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsPreview(List<Achievement> achievements) {
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Achievements',
                style: AppTextStyles.heading3,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to achievements screen
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (unlockedAchievements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No achievements yet',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...unlockedAchievements.map((achievement) => _buildAchievementItem(achievement)),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              achievement.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  achievement.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (achievement.unlockedAt != null)
            Text(
              _formatDate(achievement.unlockedAt!),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  String _getTestDisplayName(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return 'Vertical Jump';
      case TestType.shuttleRun:
        return 'Shuttle Run';
      case TestType.situps:
        return 'Sit-ups';
      case TestType.enduranceRun:
        return 'Endurance Run';
      case TestType.heightWeight:
        return 'Height & Weight';
    }
  }

  IconData _getTestIcon(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return Icons.trending_up;
      case TestType.shuttleRun:
        return Icons.directions_run;
      case TestType.situps:
        return Icons.fitness_center;
      case TestType.enduranceRun:
        return Icons.timer;
      case TestType.heightWeight:
        return Icons.straighten;
    }
  }

  Color _getTestColor(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return AppTheme.primaryColor;
      case TestType.shuttleRun:
        return AppTheme.secondaryColor;
      case TestType.situps:
        return AppTheme.accentColor;
      case TestType.enduranceRun:
        return AppColors.warning;
      case TestType.heightWeight:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
