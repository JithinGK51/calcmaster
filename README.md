# CalcMaster - Ultimate Multi-Themed Smart Calculator

## 🧮 Overview

CalcMaster is a comprehensive, feature-rich calculator application built with Flutter that combines advanced mathematical capabilities with modern design and user experience. It's designed to be the ultimate all-in-one calculator hub for students, professionals, and anyone who needs powerful calculation tools.

## ✨ Features

### 🎨 **13+ Beautiful Themes**
- Normal, Light, Dark, Kali, Hacker, Study, Kids, Glass, Cyberpunk, Nature, Galaxy, Retro Pixel, and Custom themes
- Smooth animated theme transitions
- Professional UI/UX design

### 🧮 **Advanced Calculator Features**
- **Basic Calculator**: Standard operations with BODMAS support
- **Scientific Calculator**: Trigonometry, logarithms, exponentials, roots, constants
- **Algebra Solver**: Equation solving, matrices, polynomials
- **Geometry Calculator**: 2D/3D shapes, coordinate geometry
- **Statistics**: Mean, median, mode, variance, standard deviation

### 💰 **Finance & Health Tools**
- **Finance Calculators**: EMI, interest, investment, tax calculations
- **Health Calculators**: BMI, BMR, calorie needs, body fat percentage
- **Budget Manager**: Income/expense tracking with visual charts
- **Unit & Currency Converters**: Comprehensive conversion tools

### 🔒 **Privacy & Security**
- **Privacy Vault**: Encrypted file storage with AES-256
- **Biometric Authentication**: Fingerprint and Face ID support
- **Secure Storage**: All sensitive data encrypted locally

### 🎵 **Voice & Accessibility**
- **Text-to-Speech**: 10+ voices with customizable settings
- **Speech-to-Text**: Voice input for calculations
- **Accessibility**: Full screen reader support

### 📊 **Visualization & Analytics**
- **Graph Plotting**: Function plotting with zoom and pan
- **Advanced Charts**: Professional charts using Syncfusion
- **Usage Statistics**: Detailed analytics and insights
- **Export Options**: PDF, CSV, image export capabilities

### 🔔 **Smart Features**
- **Reminders**: Customizable notifications and alerts
- **History**: Complete calculation history with search
- **Sharing**: Cross-platform sharing of results and reports
- **Performance Monitoring**: Built-in performance optimization

## 🚀 **Getting Started**

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code (recommended for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/calcmaster.git
   cd calcmaster
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

#### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

#### Desktop
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 🏗️ **Architecture**

### **Tech Stack**
- **Framework**: Flutter 3.7.2+
- **Language**: Dart
- **State Management**: Riverpod
- **Local Storage**: Hive + flutter_secure_storage
- **Charts**: fl_chart + Syncfusion Flutter Charts
- **Security**: AES-256 encryption + biometric authentication
- **Voice**: flutter_tts + speech_to_text
- **Sharing**: share_plus + PDF generation

### **Project Structure**
```
lib/
├── core/                 # Business logic and calculations
├── ui/                   # User interface components
│   ├── screens/         # App screens
│   ├── widgets/         # Reusable widgets
│   ├── themes/          # Theme definitions
│   └── animations/      # Animation components
├── services/            # External services and APIs
├── models/              # Data models with Hive adapters
├── providers/           # Riverpod state management
└── main.dart           # App entry point
```

## 🧪 **Testing**

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget/
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📱 **Platform Support**

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11.0+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🔧 **Configuration**

### Environment Setup
1. **Android**: Configure signing keys in `android/app/build.gradle`
2. **iOS**: Set up provisioning profiles and certificates
3. **Web**: Configure hosting settings for deployment
4. **Desktop**: Set up platform-specific build configurations

### Permissions
The app requires the following permissions:
- **Storage**: For file import/export and vault functionality
- **Camera**: For photo capture in privacy vault
- **Microphone**: For voice input features
- **Biometric**: For secure authentication
- **Notifications**: For reminders and alerts

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- Flutter team for the amazing framework
- All open-source package contributors
- Community feedback and suggestions

## 📞 **Support**

- **Issues**: [GitHub Issues](https://github.com/yourusername/calcmaster/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/calcmaster/discussions)
- **Email**: support@calcmaster.app

## 🗺️ **Roadmap**

### Version 1.1
- [ ] Cloud sync functionality
- [ ] Advanced AI-powered math solving
- [ ] Collaborative features
- [ ] Plugin system for custom functions

### Version 1.2
- [ ] Augmented reality calculator
- [ ] Handwriting recognition
- [ ] Advanced statistical analysis
- [ ] Custom function builder

---

**Made with ❤️ using Flutter**