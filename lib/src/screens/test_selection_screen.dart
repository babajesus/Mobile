import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../models/test_model.dart';

class TestSelectionScreen extends ConsumerWidget {
  const TestSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = _getAvailableTests();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Fitness Tests'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          final test = tests[index];
          return _buildTestCard(context, test);
        },
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, TestInfo test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Test header with icon and title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getTestColor(test.type).withOpacity(0.1),
                  _getTestColor(test.type).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTestColor(test.type).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTestIcon(test.type),
                    color: _getTestColor(test.type),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.name,
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        test.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Test details and actions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Demo video button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showDemoVideo(context, test);
                        },
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Watch Demo'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _getTestColor(test.type),
                          side: BorderSide(color: _getTestColor(test.type)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.go('/record/${test.type.name}');
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Test'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getTestColor(test.type),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Test requirements
                _buildTestRequirements(test),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestRequirements(TestInfo test) {
    final requirements = _getTestRequirements(test.type);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requirements:',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...requirements.map((requirement) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 16,
                color: AppTheme.successColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  requirement,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  void _showDemoVideo(BuildContext context, TestInfo test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${test.name} Demo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Demo Video Placeholder',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This is a placeholder for the ${test.name.toLowerCase()} demonstration video.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<TestInfo> _getAvailableTests() {
    return [
      TestInfo(
        type: TestType.verticalJump,
        name: 'Vertical Jump',
        description: 'Measure your explosive leg power',
        icon: '🦘',
        demoVideoPath: 'assets/demos/vertical_jump.mp4',
        unit: 'cm',
        benchmarks: {'male_25': 50.0, 'female_25': 35.0},
      ),
      TestInfo(
        type: TestType.shuttleRun,
        name: 'Shuttle Run',
        description: 'Test your agility and speed',
        icon: '🏃‍♂️',
        demoVideoPath: 'assets/demos/shuttle_run.mp4',
        unit: 'seconds',
        benchmarks: {'male_25': 10.0, 'female_25': 12.0},
      ),
      TestInfo(
        type: TestType.situps,
        name: 'Sit-ups',
        description: 'Assess your core strength',
        icon: '💪',
        demoVideoPath: 'assets/demos/situps.mp4',
        unit: 'reps',
        benchmarks: {'male_25': 30.0, 'female_25': 25.0},
      ),
      TestInfo(
        type: TestType.enduranceRun,
        name: 'Endurance Run',
        description: 'Test your cardiovascular fitness',
        icon: '🏃‍♀️',
        demoVideoPath: 'assets/demos/endurance_run.mp4',
        unit: 'minutes',
        benchmarks: {'male_25': 8.0, 'female_25': 10.0},
      ),
      TestInfo(
        type: TestType.heightWeight,
        name: 'Height & Weight',
        description: 'Record your basic measurements',
        icon: '📏',
        demoVideoPath: 'assets/demos/height_weight.mp4',
        unit: 'cm/kg',
        benchmarks: {},
      ),
    ];
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

  List<String> _getTestRequirements(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return [
          'Clear space above your head',
          'Stand straight with feet shoulder-width apart',
          'Jump as high as possible',
        ];
      case TestType.shuttleRun:
        return [
          'Marked 20-meter distance',
          'Two cones or markers',
          'Stopwatch or timer',
        ];
      case TestType.situps:
        return [
          'Flat surface to lie on',
          'Bent knees at 90 degrees',
          'Hands behind your head',
        ];
      case TestType.enduranceRun:
        return [
          'Track or measured distance',
          'Comfortable running shoes',
          'Stopwatch or timer',
        ];
      case TestType.heightWeight:
        return [
          'Measuring tape or ruler',
          'Scale for weight measurement',
          'Flat surface for accurate reading',
        ];
    }
  }
}
