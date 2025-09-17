import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../models/test_model.dart';
import '../providers/app_providers.dart';

class ResultsScreen extends ConsumerWidget {
  final String testType;
  final double score;
  
  const ResultsScreen({
    super.key,
    required this.testType,
    required this.score,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testTypeEnum = TestType.values.firstWhere(
      (e) => e.name == testType,
    );
    
    final user = ref.watch(userProvider);
    final benchmark = _getBenchmark(testTypeEnum, user);
    final performanceLevel = _getPerformanceLevel(score, benchmark);
    final suggestion = _getSuggestion(testTypeEnum, performanceLevel);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('${_getTestDisplayName(testTypeEnum)} Results'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score card
            _buildScoreCard(testTypeEnum, score, performanceLevel),
            
            const SizedBox(height: 24),
            
            // Benchmark comparison
            _buildBenchmarkCard(benchmark, performanceLevel),
            
            const SizedBox(height: 24),
            
            // Suggestion card
            _buildSuggestionCard(suggestion),
            
            const SizedBox(height: 24),
            
            // Action buttons
            _buildActionButtons(context, ref),
            
            const SizedBox(height: 24),
            
            // Test details
            _buildTestDetailsCard(testTypeEnum),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(TestType testType, double score, String performanceLevel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getPerformanceColor(performanceLevel),
            _getPerformanceColor(performanceLevel).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getPerformanceColor(performanceLevel).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${score.toStringAsFixed(1)} ${_getTestUnit(testType)}',
            style: AppTextStyles.heading1.copyWith(
              color: Colors.white,
              fontSize: 48,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              performanceLevel,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenchmarkCard(double benchmark, String performanceLevel) {
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
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Benchmark Comparison',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Performance indicator
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Performance',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: _getPerformancePercentage(performanceLevel),
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPerformanceColor(performanceLevel),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(_getPerformancePercentage(performanceLevel) * 100).toInt()}%',
                style: AppTextStyles.heading3.copyWith(
                  color: _getPerformanceColor(performanceLevel),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Benchmark info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Average for your age group: ${benchmark.toStringAsFixed(1)} ${_getTestUnit(TestType.values.firstWhere((e) => e.name == testType))}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String suggestion) {
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
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Improvement Tips',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            suggestion,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              context.go('/test-selection');
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retake Test'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: const BorderSide(color: AppTheme.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Save result and go to home
              _saveResult(ref);
              context.go('/home');
            },
            icon: const Icon(Icons.save),
            label: const Text('Save & Continue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestDetailsCard(TestType testType) {
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
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Test Information',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow('Test Type', _getTestDisplayName(testType)),
          _buildInfoRow('Unit', _getTestUnit(testType)),
          _buildInfoRow('Completed', DateTime.now().toString().split(' ')[0]),
          _buildInfoRow('Duration', '10 seconds'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _saveResult(WidgetRef ref) {
    final testTypeEnum = TestType.values.firstWhere(
      (e) => e.name == testType,
    );
    
    final result = TestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: ref.read(userProvider)?.id ?? 'user_1',
      testType: testTypeEnum,
      score: score,
      unit: _getTestUnit(testTypeEnum),
      completedAt: DateTime.now(),
    );
    
    ref.read(testResultsProvider.notifier).addResult(result);
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

  String _getTestUnit(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return 'cm';
      case TestType.shuttleRun:
        return 'sec';
      case TestType.situps:
        return 'reps';
      case TestType.enduranceRun:
        return 'min';
      case TestType.heightWeight:
        return 'cm/kg';
    }
  }

  double _getBenchmark(TestType testType, user) {
    // Mock benchmarks based on test type
    switch (testType) {
      case TestType.verticalJump:
        return 45.0;
      case TestType.shuttleRun:
        return 12.0;
      case TestType.situps:
        return 25.0;
      case TestType.enduranceRun:
        return 10.0;
      case TestType.heightWeight:
        return 170.0;
    }
  }

  String _getPerformanceLevel(double score, double benchmark) {
    final ratio = score / benchmark;
    if (ratio >= 1.2) return 'Excellent';
    if (ratio >= 1.0) return 'Good';
    if (ratio >= 0.8) return 'Average';
    return 'Below Average';
  }

  Color _getPerformanceColor(String level) {
    switch (level) {
      case 'Excellent':
        return AppTheme.successColor;
      case 'Good':
        return AppTheme.primaryColor;
      case 'Average':
        return AppColors.warning;
      case 'Below Average':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  double _getPerformancePercentage(String level) {
    switch (level) {
      case 'Excellent':
        return 1.0;
      case 'Good':
        return 0.8;
      case 'Average':
        return 0.6;
      case 'Below Average':
        return 0.4;
      default:
        return 0.5;
    }
  }

  String _getSuggestion(TestType testType, String performanceLevel) {
    switch (testType) {
      case TestType.verticalJump:
        return performanceLevel == 'Below Average' || performanceLevel == 'Average'
            ? 'Focus on leg strength training, plyometric exercises, and proper jumping technique. Practice squats, lunges, and box jumps to improve your vertical jump.'
            : 'Great job! Continue with your current training routine and consider adding more challenging plyometric exercises.';
      case TestType.situps:
        return performanceLevel == 'Below Average' || performanceLevel == 'Average'
            ? 'Strengthen your core with planks, Russian twists, and leg raises. Focus on proper form and controlled movements rather than speed.'
            : 'Excellent core strength! Keep up the good work and consider adding weighted exercises to challenge yourself further.';
      case TestType.shuttleRun:
        return performanceLevel == 'Below Average' || performanceLevel == 'Average'
            ? 'Improve your agility with ladder drills, cone exercises, and interval training. Focus on quick direction changes and acceleration.'
            : 'Great agility! Continue with agility training and consider adding more complex movement patterns.';
      case TestType.enduranceRun:
        return performanceLevel == 'Below Average' || performanceLevel == 'Average'
            ? 'Build cardiovascular endurance with regular running, interval training, and cross-training activities like cycling or swimming.'
            : 'Outstanding endurance! Maintain your training routine and consider longer distance challenges.';
      case TestType.heightWeight:
        return 'Maintain a balanced diet and regular exercise routine. Focus on building lean muscle mass and maintaining a healthy body composition.';
    }
  }
}
