/// Application asset paths
class AppAssets {
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images/';
  static const String _iconsPath = 'assets/icons/';
  static const String _logosPath = 'assets/logos/';

  // Logos
  static const String appLogo = '${_logosPath}app_logo.png';
  static const String schoolLogo = '${_logosPath}school_logo.png';

  // Images
  static const String loginBackground = '${_imagesPath}login_background.png';
  static const String dashboardBackground = '${_imagesPath}dashboard_background.png';
  static const String emptyState = '${_imagesPath}empty_state.png';
  static const String noNotifications = '${_imagesPath}no_notifications.png';
  static const String noEvents = '${_imagesPath}no_events.png';
  static const String noDiary = '${_imagesPath}no_diary.png';
  static const String profilePlaceholder = '${_imagesPath}profile_placeholder.png';
  static const String childPlaceholder = '${_imagesPath}child_placeholder.png';

  // Icons
  static const String attendanceIcon = '${_iconsPath}attendance.svg';
  static const String feesIcon = '${_iconsPath}fees.svg';
  static const String diaryIcon = '${_iconsPath}diary.svg';
  static const String eventsIcon = '${_iconsPath}events.svg';
  static const String notificationIcon = '${_iconsPath}notification.svg';
  static const String profileIcon = '${_iconsPath}profile.svg';
  static const String homeIcon = '${_iconsPath}home.svg';
  static const String calendarIcon = '${_iconsPath}calendar.svg';
  static const String mealIcon = '${_iconsPath}meal.svg';
  static const String playIcon = '${_iconsPath}play.svg';
  static const String studyIcon = '${_iconsPath}study.svg';
  static const String napIcon = '${_iconsPath}nap.svg';
  static const String specialActivityIcon = '${_iconsPath}special_activity.svg';

  // Activity Type Icons (for diary)
  static const Map<String, String> activityIcons = {
    'meal': mealIcon,
    'play': playIcon,
    'study': studyIcon,
    'nap': napIcon,
    'special': specialActivityIcon,
  };
}
