# Quick Start Guide - Parent Management System

## 🚀 Get Started in 5 Minutes

### Prerequisites
Ensure you have the following installed:
- Flutter SDK (3.10.3+)
- Dart SDK (3.10.3+)
- Android Studio or VS Code
- Git

### Step 1: Clone & Setup
```bash
# Clone the repository
git clone <repository-url>
cd pms

# Install dependencies
flutter pub get

# Verify installation
flutter doctor
```

### Step 2: Run the App
```bash
# Run on connected device/emulator
flutter run

# Or specify a device
flutter run -d chrome    # For web
flutter run -d android   # For Android
flutter run -d ios       # For iOS
```

### Step 3: Login
Use these test credentials:
- **Email:** `parent@example.com`
- **Password:** `password123`

---

## 📱 App Navigation

### Bottom Navigation Bar
1. **Home** - Dashboard with child selector and quick stats
2. **Diary** - Daily activities (placeholder)
3. **Fees** - Fee management (placeholder)
4. **Events** - School events (placeholder)
5. **Profile** - User profile and settings

---

## 🎨 Key Features (Phase 1)

### ✅ Implemented Features

#### 1. Authentication
- Login with email/password
- Form validation
- Remember me checkbox
- Biometric login UI (not functional yet)

#### 2. Dashboard
- **Child Selector Carousel**
  - Swipe to switch between children
  - Shows attendance and fee status
  - Add child button (UI only)

- **Quick Stats Grid**
  - Attendance percentage
  - Fee status
  - Diary updates count
  - Upcoming events count

- **Activity Preview**
  - Recent 3 activities
  - Time-based timeline
  - Activity icons and descriptions

- **Announcements**
  - Latest school announcements
  - Priority badges

#### 3. Profile
- User information display
- Settings sections:
  - Account settings
  - Notification preferences
  - Appearance (theme toggle UI)
  - About section
- Logout with confirmation

---

## 🔧 Development Tips

### Hot Reload
Press `r` in terminal or use IDE hot reload button to see changes instantly.

### Debug Mode
```bash
# Run with debug logging
flutter run --verbose

# Run with specific flavor
flutter run --flavor dev
```

### Code Generation (for future use)
```bash
# Generate Hive adapters
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

---

## 📁 Project Structure Overview

```
lib/
├── core/               # Core app functionality
│   ├── constants/     # Colors, strings, theme
│   └── routes/        # Navigation
│
├── features/          # Feature modules
│   ├── authentication/
│   ├── dashboard/
│   ├── diary/
│   ├── fees/
│   ├── events/
│   ├── profile/
│   └── notifications/
│
├── shared/            # Shared resources
│   ├── models/       # Data models
│   └── widgets/      # Reusable widgets
│
└── main.dart         # App entry point
```

---

## 🎯 Common Tasks

### Adding a New Feature
1. Create feature folder in `lib/features/`
2. Add data models in `data/models/`
3. Create provider in `presentation/providers/`
4. Build UI in `presentation/pages/`
5. Add route in `core/routes/app_router.dart`

### Creating a Reusable Widget
1. Add widget file in `lib/shared/widgets/`
2. Organize by category (buttons, cards, inputs, etc.)
3. Use theme constants from `app_theme.dart`
4. Make it configurable with parameters

### Adding a New Color
1. Open `lib/core/constants/app_colors.dart`
2. Add color for both light and dark modes
3. Use in widgets via `Theme.of(context).colorScheme`

### Adding a New String
1. Open `lib/core/constants/app_strings.dart`
2. Add constant with descriptive name
3. Use throughout the app for consistency

---

## 🐛 Troubleshooting

### Issue: Dependencies not installing
```bash
flutter clean
flutter pub get
```

### Issue: Build errors
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Issue: Hot reload not working
- Restart the app completely
- Check for syntax errors
- Ensure you're in debug mode

### Issue: Theme not applying
- Check `main.dart` theme configuration
- Verify `ThemeMode` is set correctly
- Restart the app

---

## 📊 Testing the App

### Manual Testing Checklist
- [ ] Login with valid credentials
- [ ] Login with invalid credentials (should show error)
- [ ] Check "Remember Me" and restart app
- [ ] Navigate through all bottom nav tabs
- [ ] Swipe through child selector
- [ ] Tap on stats cards
- [ ] Pull to refresh on dashboard
- [ ] Open profile settings
- [ ] Logout (should show confirmation)
- [ ] Test on different screen sizes

---

## 🎨 Customization

### Change App Name
1. Update `pubspec.yaml`: `name: your_app_name`
2. Update `AppStrings.appName` in `app_strings.dart`

### Change Theme Colors
1. Open `lib/core/constants/app_colors.dart`
2. Modify color values
3. Hot reload to see changes

### Change Font
1. Open `lib/core/constants/app_theme.dart`
2. Replace `GoogleFonts.inter` with your font
3. Ensure font is added to `pubspec.yaml`

---

## 📱 Building for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS
```bash
flutter build ios --release
```
Then open Xcode to archive and upload.

---

## 🔗 Useful Commands

```bash
# Check Flutter installation
flutter doctor

# List connected devices
flutter devices

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .

# Clean build files
flutter clean

# Upgrade dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

---

## 📚 Next Steps

### For Developers
1. Review `IMPLEMENTATION_PLAN.md` for upcoming features
2. Check `README.md` for detailed documentation
3. Explore the codebase structure
4. Start implementing Phase 2 features

### For Designers
1. Review design system in `app_theme.dart`
2. Check color palette in `app_colors.dart`
3. Provide UI mockups for pending features
4. Create app icons and splash screens

### For Project Managers
1. Review implementation plan
2. Set up project tracking (Jira, Trello, etc.)
3. Define sprint goals
4. Schedule team meetings

---

## 💡 Pro Tips

1. **Use Hot Reload** - Save time during development
2. **Follow the Structure** - Keep code organized by feature
3. **Reuse Widgets** - Check `shared/widgets/` before creating new ones
4. **Use Constants** - Never hardcode strings or colors
5. **Test on Real Devices** - Emulators don't show everything
6. **Keep Dependencies Updated** - Run `flutter pub upgrade` regularly
7. **Use Version Control** - Commit often with meaningful messages
8. **Document Your Code** - Future you will thank you

---

## 🆘 Need Help?

- Check the [README.md](README.md) for detailed documentation
- Review the [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) for feature roadmap
- Search [Flutter Documentation](https://flutter.dev/docs)
- Visit [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- Join [Flutter Community](https://flutter.dev/community)

---

**Happy Coding! 🚀**

*Last Updated: January 9, 2026*
