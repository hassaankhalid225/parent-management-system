# Parent Management System (PMS)

A comprehensive Flutter application for parents to stay connected with their child's educational journey. Built with a modular architecture following clean code principles.

## 📱 Features

### ✅ Implemented (Phase 1)
- **Authentication System**
  - Login with email/password
  - Remember me functionality
  - Biometric login support (UI ready)
  - Form validation
  
- **Dashboard**
  - Multi-child support with carousel selector
  - Quick stats cards (Attendance, Fees, Diary, Events)
  - Activity preview timeline
  - Recent announcements
  - Pull-to-refresh functionality
  
- **Navigation**
  - Bottom navigation bar
  - GoRouter integration
  - Smooth page transitions
  
- **Profile Management**
  - User profile display
  - Settings sections
  - Logout functionality
  - Theme toggle (UI ready)

### 🚧 Under Development (Phase 2)
- **Daily Diary**
  - Activity timeline with filters
  - Media attachments
  - Teacher comments
  - Parent replies
  - PDF export
  
- **Fee Management**
  - Fee breakdown by category
  - Payment history
  - Online payment integration
  - Receipt generation
  - Payment reminders
  
- **Events & Activities**
  - Calendar view
  - Event registration
  - RSVP functionality
  - Permission slip management
  - Event gallery
  
- **Notifications**
  - Push notifications
  - In-app notifications
  - Notification filtering
  - Mark as read/unread

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # Color palette
│   │   ├── app_strings.dart      # String constants
│   │   ├── app_assets.dart       # Asset paths
│   │   └── app_theme.dart        # Theme configuration
│   └── routes/
│       └── app_router.dart       # GoRouter configuration
│
├── features/
│   ├── authentication/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── login_page.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── dashboard_page.dart
│   │       ├── providers/
│   │       │   └── dashboard_provider.dart
│   │       └── widgets/
│   │           └── child_selector_card.dart
│   │
│   ├── diary/
│   ├── fees/
│   ├── events/
│   ├── profile/
│   └── notifications/
│
├── shared/
│   ├── models/
│   │   ├── child_model.dart
│   │   └── user_model.dart
│   └── widgets/
│       ├── buttons/
│       │   └── primary_button.dart
│       ├── cards/
│       │   └── stats_card.dart
│       ├── inputs/
│       │   └── custom_text_field.dart
│       └── feedback/
│           ├── loading_indicator.dart
│           └── empty_state_widget.dart
│
└── main.dart
```

## 🎨 Design System

### Color Palette

**Light Mode:**
- Primary: `#6C63FF` (Purple)
- Secondary: `#FF6584` (Pink)
- Accent: `#4ECDC4` (Teal)
- Success: `#00B894` (Green)
- Warning: `#FDCB6E` (Yellow)
- Error: `#D63031` (Red)

**Dark Mode:**
- Primary: `#8B83FF`
- Secondary: `#FF7A93`
- Accent: `#6EDFD6`
- Success: `#00D2A0`
- Warning: `#FFD93D`
- Error: `#FF6B6B`

### Typography
- Font Family: **Inter** (Google Fonts)
- Heading 1: 32sp, Bold
- Heading 2: 24sp, Bold
- Heading 3: 20sp, SemiBold
- Body 1: 16sp, Regular
- Body 2: 14sp, Regular
- Caption: 12sp, Regular

### Spacing
- Extra Small: 4px
- Small: 8px
- Medium: 16px
- Large: 24px
- Extra Large: 32px

### Border Radius
- Small: 8px
- Medium: 12px
- Large: 16px
- Extra Large: 24px

## 🛠️ Tech Stack

### Core
- **Flutter**: 3.10.3+
- **Dart**: 3.10.3+

### State Management
- **Provider**: 6.1.1

### Navigation
- **GoRouter**: 14.6.2

### API Integration
- **Dio**: 5.4.0

### Local Storage
- **Hive**: 2.2.3
- **SharedPreferences**: 2.2.2

### UI Components
- **Google Fonts**: 6.1.0
- **Cached Network Image**: 3.3.1
- **Shimmer**: 3.0.0
- **Flutter SVG**: 2.0.9

### Utilities
- **Intl**: 0.19.0 (Date formatting)
- **UUID**: 4.3.3
- **Image Picker**: 1.0.7
- **URL Launcher**: 6.2.4
- **Share Plus**: 7.2.2

### Additional Features
- **PDF Generation**: pdf 3.10.7, printing 5.12.0
- **Biometric Auth**: local_auth 2.1.8
- **Video Player**: video_player 2.8.2
- **Calendar**: table_calendar 3.0.9

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.3 or higher)
- Dart SDK (3.10.3 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pms
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 📝 Development Guidelines

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### State Management
- Use Provider for state management
- Create separate providers for each feature
- Use `ChangeNotifier` for reactive state updates
- Dispose controllers and listeners properly

### File Naming
- Use snake_case for file names
- Use PascalCase for class names
- Use camelCase for variables and functions

### Widget Organization
- Keep widgets small and reusable
- Extract complex widgets into separate files
- Use const constructors where possible
- Prefer composition over inheritance

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

## 📦 Build & Release

### Version Management
Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

### Android Release
1. Update `android/app/build.gradle`
2. Generate signing key
3. Build release APK:
   ```bash
   flutter build apk --release
   ```

### iOS Release
1. Update `ios/Runner/Info.plist`
2. Configure signing in Xcode
3. Build release:
   ```bash
   flutter build ios --release
   ```

## 🔧 Configuration

### Firebase Setup (TODO)
1. Create Firebase project
2. Add `google-services.json` (Android)
3. Add `GoogleService-Info.plist` (iOS)
4. Initialize Firebase in `main.dart`

### API Configuration (TODO)
Update API base URL in `lib/core/services/api_service.dart`

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io/)

## 👥 Contributors

- Your Name - Lead Developer

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for Inter font family
- All package maintainers

---

**Note:** This is Phase 1 of the project. Additional features (Diary, Fees, Events, Notifications) will be implemented in subsequent phases.
