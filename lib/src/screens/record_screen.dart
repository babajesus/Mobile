import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/movenet_service.dart';
import '../theme/app_theme.dart';
import '../models/test_model.dart';

class RecordScreen extends ConsumerStatefulWidget {
  final String testType;
  const RecordScreen({super.key, required this.testType});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  late Future<void> _initFuture;
  final MoveNetService _pose = MoveNetService();
  String _status = 'Initializing';
  bool _isRecording = false;
  bool _isCountdownActive = false;
  int _countdownValue = 3;
  late AnimationController _countdownController;
  late Animation<double> _countdownAnimation;
  String? _aiFeedback;

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
    _countdownController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _countdownAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _countdownController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _init() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller!.initialize();
    await _pose.loadModel();
    setState(() => _status = 'Ready');
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pose.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  Future<void> _startCountdown() async {
    setState(() {
      _isCountdownActive = true;
      _countdownValue = 3;
    });

    _countdownController.reset();
    _countdownController.forward();

    for (int i = 3; i > 0; i--) {
      setState(() {
        _countdownValue = i;
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() {
      _isCountdownActive = false;
    });

    await _startRecording();
  }

  Future<void> _startRecording() async {
    if (!(_controller?.value.isInitialized ?? false)) return;
    
    setState(() {
      _status = 'Recording';
      _isRecording = true;
    });

    // Start video recording
    await _controller!.startVideoRecording();
    
    // Simulate AI feedback during recording
    _simulateAIFeedback();
    
    // Auto-stop after 10 seconds for demo
    await Future.delayed(const Duration(seconds: 10));
    
    if (_isRecording) {
      await _stopRecording();
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    
    setState(() {
      _status = 'Processing';
      _isRecording = false;
    });

    await _controller!.stopVideoRecording();

    // Simulate analysis
    await Future.delayed(const Duration(seconds: 2));
    
    final testType = TestType.values.firstWhere(
      (e) => e.name == widget.testType,
    );
    
    // Generate mock score based on test type
    final mockScore = _generateMockScore(testType);
    
    if (mounted) {
      context.go('/results/${widget.testType}/$mockScore');
    }
  }

  void _simulateAIFeedback() {
    final testType = TestType.values.firstWhere(
      (e) => e.name == widget.testType,
    );
    
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isRecording) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _aiFeedback = _getAIFeedback(testType);
      });
    });
  }

  String _getAIFeedback(TestType type) {
    final feedbacks = {
      TestType.verticalJump: [
        'Good form! Keep your arms swinging',
        'Jump higher! Use your legs',
        'Perfect landing position',
      ],
      TestType.situps: [
        'Great pace! Keep it up',
        'Focus on your breathing',
        'Excellent form - 15 reps counted',
      ],
      TestType.shuttleRun: [
        'Fast turn! Good agility',
        'Maintain your speed',
        'Great acceleration',
      ],
      TestType.enduranceRun: [
        'Steady pace - looking good',
        'Keep your breathing rhythm',
        'You\'re doing great!',
      ],
    };
    
    final typeFeedbacks = feedbacks[type] ?? ['Keep going!'];
    return typeFeedbacks[DateTime.now().second % typeFeedbacks.length];
  }

  double _generateMockScore(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return 35.0 + (DateTime.now().millisecond % 20);
      case TestType.situps:
        return 20.0 + (DateTime.now().millisecond % 15);
      case TestType.shuttleRun:
        return 10.0 + (DateTime.now().millisecond % 5);
      case TestType.enduranceRun:
        return 8.0 + (DateTime.now().millisecond % 3);
      case TestType.heightWeight:
        return 175.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final testType = TestType.values.firstWhere(
      (e) => e.name == widget.testType,
    );
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_getTestDisplayName(testType)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showTestInstructions(context, testType);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          
          return Stack(
            children: [
              // Camera preview
              Positioned.fill(
                child: CameraPreview(_controller!),
              ),
              
              // Bounding box guide
              if (_status == 'Ready' || _status == 'Recording')
                Positioned.fill(
                  child: CustomPaint(
                    painter: BoundingBoxPainter(),
                  ),
                ),
              
              // Countdown overlay
              if (_isCountdownActive)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _countdownAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _countdownAnimation.value + 0.5,
                            child: Text(
                              '$_countdownValue',
                              style: const TextStyle(
                                fontSize: 120,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              
              // AI Feedback overlay
              if (_aiFeedback != null && _isRecording)
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _aiFeedback!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              // Status overlay
              Positioned(
                top: 50,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // Control buttons
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Retake button
                    if (_status == 'Ready')
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.close),
                      ),
                    
                    // Record button
                    FloatingActionButton(
                      onPressed: _isRecording ? _stopRecording : _startCountdown,
                      backgroundColor: _isRecording ? Colors.red : AppTheme.primaryColor,
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.play_arrow,
                        size: 32,
                      ),
                    ),
                    
                    // Settings button
                    if (_status == 'Ready')
                      FloatingActionButton(
                        onPressed: () {
                          // Handle settings
                        },
                        backgroundColor: Colors.grey[600],
                        child: const Icon(Icons.settings),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getTestDisplayName(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return 'Vertical Jump Test';
      case TestType.shuttleRun:
        return 'Shuttle Run Test';
      case TestType.situps:
        return 'Sit-ups Test';
      case TestType.enduranceRun:
        return 'Endurance Run Test';
      case TestType.heightWeight:
        return 'Height & Weight';
    }
  }

  void _showTestInstructions(BuildContext context, TestType type) {
    final instructions = _getTestInstructions(type);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTestDisplayName(type)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: instructions.map((instruction) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(instruction)),
              ],
            ),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  List<String> _getTestInstructions(TestType type) {
    switch (type) {
      case TestType.verticalJump:
        return [
          'Stand straight with feet shoulder-width apart',
          'Bend your knees slightly',
          'Swing your arms and jump as high as possible',
          'Land softly on both feet',
        ];
      case TestType.situps:
        return [
          'Lie on your back with knees bent',
          'Place hands behind your head',
          'Lift your upper body until elbows touch knees',
          'Lower back down slowly',
        ];
      case TestType.shuttleRun:
        return [
          'Start at the first cone',
          'Run to the second cone and touch it',
          'Return to the first cone',
          'Repeat as fast as possible',
        ];
      case TestType.enduranceRun:
        return [
          'Start running at a comfortable pace',
          'Maintain steady breathing',
          'Keep consistent speed throughout',
          'Stop when you feel exhausted',
        ];
      case TestType.heightWeight:
        return [
          'Stand straight against a wall',
          'Keep feet flat on the ground',
          'Look straight ahead',
          'Record your height and weight',
        ];
    }
  }
}

class BoundingBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw bounding box in center
    final boxWidth = size.width * 0.8;
    final boxHeight = size.height * 0.6;
    final boxLeft = (size.width - boxWidth) / 2;
    final boxTop = (size.height - boxHeight) / 2;

    final rect = Rect.fromLTWH(boxLeft, boxTop, boxWidth, boxHeight);
    canvas.drawRect(rect, paint);

    // Draw corner markers
    final cornerLength = 20.0;
    final cornerPaint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Top-left corner
    canvas.drawLine(
      Offset(boxLeft, boxTop),
      Offset(boxLeft + cornerLength, boxTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft, boxTop),
      Offset(boxLeft, boxTop + cornerLength),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop),
      Offset(boxLeft + boxWidth - cornerLength, boxTop),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop),
      Offset(boxLeft + boxWidth, boxTop + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(boxLeft, boxTop + boxHeight),
      Offset(boxLeft + cornerLength, boxTop + boxHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft, boxTop + boxHeight),
      Offset(boxLeft, boxTop + boxHeight - cornerLength),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop + boxHeight),
      Offset(boxLeft + boxWidth - cornerLength, boxTop + boxHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(boxLeft + boxWidth, boxTop + boxHeight),
      Offset(boxLeft + boxWidth, boxTop + boxHeight - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


