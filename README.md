# SAI Talent Assessment Mobile App

A comprehensive fitness assessment platform built with Flutter, featuring AI-powered analysis, progress tracking, and competitive leaderboards.

## 🚀 Features

### 📱 Core Screens & Navigation
- **Splash & Onboarding**: App introduction with permission requests
- **Authentication**: Login/Registration with profile setup
- **Home Dashboard**: Quick access to all features with motivational content
- **Test Selection**: Choose from various fitness tests with demo videos
- **Recording Screen**: AI-powered camera interface with countdown timer
- **Results & Feedback**: Detailed analysis with benchmarks and suggestions
- **Progress Tracking**: Charts and visualizations of performance over time
- **Leaderboard**: Regional, state, and national rankings
- **Achievements**: Badge system with streak tracking
- **Profile & Settings**: User management with theme and language options

### 🎯 Fitness Tests
- **Vertical Jump**: Measure explosive leg power
- **Shuttle Run**: Test agility and speed
- **Sit-ups**: Assess core strength
- **Endurance Run**: Cardiovascular fitness evaluation
- **Height & Weight**: Basic measurements

### 🤖 AI Features
- Real-time pose detection using MoveNet
- Live feedback during test execution
- Automatic rep counting and form analysis
- Performance scoring and benchmarking

### 📊 Analytics & Progress
- Interactive charts showing performance trends
- Achievement system with unlockable badges
- Streak tracking for motivation
- Comprehensive progress reports

### 🏆 Social Features
- Multi-level leaderboards (Regional/State/National)
- Achievement sharing capabilities
- Performance comparisons with peers

### 🎨 Design & UX
- Clean, minimal Material Design 3
- Dark/Light mode support
- Multilingual support (English/Hindi)
- Responsive layout for all screen sizes
- Smooth animations and transitions

## 🛠 Technical Stack

### Core Technologies
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Riverpod**: State management
- **GoRouter**: Navigation and routing

### AI & Computer Vision
- **TensorFlow Lite**: On-device AI inference
- **MoveNet**: Pose detection model
- **Camera**: Real-time video capture and analysis

### UI & Design
- **Material Design 3**: Modern UI components
- **FL Chart**: Data visualization and charts
- **Lottie**: Smooth animations
- **Shimmer**: Loading states

### Data & Storage
- **SQLite**: Local data storage
- **SharedPreferences**: User preferences
- **Path Provider**: File system access

### Additional Features
- **Image Picker**: Profile picture management
- **Permission Handler**: Camera and storage permissions
- **Connectivity Plus**: Network status monitoring
- **Geolocator**: Location services

## 📁 Project Structure

```
mobile/
├── lib/
│   ├── main.dart                 # App entry point
│   └── src/
│       ├── app.dart             # Main app configuration
│       ├── models/              # Data models
│       │   ├── user_model.dart
│       │   ├── test_model.dart
│       │   └── achievement_model.dart
│       ├── providers/           # State management
│       │   └── app_providers.dart
│       ├── screens/            # UI screens
│       │   ├── splash_screen.dart
│       │   ├── onboarding_screen.dart
│       │   ├── login_screen.dart
│       │   ├── registration_screen.dart
│       │   ├── home_screen.dart
│       │   ├── test_selection_screen.dart
│       │   ├── record_screen.dart
│       │   ├── results_screen.dart
│       │   ├── progress_screen.dart
│       │   ├── leaderboard_screen.dart
│       │   ├── achievements_screen.dart
│       │   └── profile_screen.dart
│       ├── services/            # Business logic
│       │   └── movenet_service.dart
│       ├── theme/               # App theming
│       │   └── app_theme.dart
│       └── navigation/          # Routing
│           └── app_router.dart
├── pubspec.yaml                # Dependencies
└── README.md                   # This file
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.5.0)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add AI model**
   - Download the MoveNet model file
   - Place it in `assets/models/movenet_single_pose_lightning.tflite`

4. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### Camera Permissions
Add the following permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### AI Model Setup
1. Download the MoveNet model from TensorFlow Hub
2. Place the `.tflite` file in `assets/models/`
3. Update `pubspec.yaml` to include the asset

## 🎯 Usage Guide

### For Athletes
1. **Sign Up**: Create account with personal details
2. **Take Tests**: Select and complete fitness assessments
3. **Track Progress**: Monitor improvement over time
4. **Compete**: Compare scores on leaderboards
5. **Achieve**: Unlock badges and maintain streaks

### For Coaches/Trainers
1. **Monitor Athletes**: View progress and performance data
2. **Set Benchmarks**: Establish performance standards
3. **Track Improvements**: Analyze trends and patterns
4. **Motivate**: Use achievements and leaderboards

## 🔧 Customization

### Adding New Tests
1. Define test type in `TestType` enum
2. Add test information in `TestInfo` class
3. Implement recording logic in `RecordScreen`
4. Add scoring algorithm in `ResultsScreen`

### Theming
- Modify `AppTheme` class for color schemes
- Update `AppTextStyles` for typography
- Customize component styles in individual screens

### Localization
- Add new languages in `supportedLocales`
- Create translation files
- Update UI text to use localized strings

## 📱 App Flow

```
Splash → Onboarding → Login/Register → Home Dashboard
    ↓
Test Selection → Recording → Results → Progress Tracking
    ↓
Leaderboard ← Achievements ← Profile & Settings
```

## 🎨 Design Guidelines

### Color Palette
- **Primary**: Green (#2E7D32)
- **Secondary**: Light Green (#4CAF50)
- **Accent**: Lime (#8BC34A)
- **Success**: Green (#4CAF50)
- **Warning**: Orange (#FF9800)
- **Error**: Red (#E53935)

### Typography
- **Headings**: Bold, clear hierarchy
- **Body**: Readable, appropriate sizing
- **Buttons**: Prominent, action-oriented

### Layout Principles
- **Clean**: Minimal, uncluttered design
- **Consistent**: Uniform spacing and alignment
- **Accessible**: High contrast, readable text
- **Responsive**: Adapts to different screen sizes

## 🔒 Privacy & Security

### Data Protection
- Local data storage with encryption
- No personal data transmitted without consent
- Anonymous analytics for research purposes
- User control over data sharing preferences

### Permissions
- Camera: Required for test recording
- Storage: For saving test results
- Location: Optional for regional leaderboards

## 🚀 Performance

### Optimization
- Efficient AI model inference
- Optimized image processing
- Smooth animations and transitions
- Minimal battery usage

### Target Specifications
- **App Size**: <50MB
- **Memory Usage**: <100MB
- **Battery Impact**: Minimal during testing
- **Performance**: 60fps UI, <2s test analysis

## 🐛 Troubleshooting

### Common Issues

1. **Camera not working**
   - Check device permissions
   - Ensure camera is not used by other apps
   - Restart the app

2. **AI analysis slow**
   - Close other apps to free memory
   - Ensure good lighting conditions
   - Check device compatibility

3. **App crashes on startup**
   - Clear app data and restart
   - Check Flutter version compatibility
   - Reinstall the app

### Debug Mode
Enable debug logging by setting `debugShowCheckedModeBanner: true` in `main.dart`

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Standards
- Follow Flutter/Dart conventions
- Write comprehensive tests
- Document new features
- Maintain code quality

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Sports Authority of India** for the initiative
- **TensorFlow** for AI model support
- **Flutter Team** for the excellent framework
- **Open Source Community** for various packages

## 📞 Support

For support and questions:
- **Email**: support@saitalent.com
- **Documentation**: [Wiki](link-to-wiki)
- **Issues**: [GitHub Issues](link-to-issues)

---

**Built with ❤️ for Indian athletes and fitness enthusiasts**
