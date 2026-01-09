class ApiEndpoints {
  static const String baseUrl = 'https://api.pms-school.com/v1'; // Placeholder URL

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String profile = '/auth/profile';

  // Dashboard & Children
  static const String children = '/children';
  static String childStats(String childId) => '/children/$childId/stats';
  
  // Diary
  static String diary(String childId) => '/children/$childId/diary';
  static String addDiaryComment(String entryId) => '/diary/$entryId/comments';

  // Fees
  static String fees(String childId) => '/children/$childId/fees';
  static String payFee(String feeId) => '/fees/$feeId/pay';

  // Events
  static const String events = '/events';
  static String rsvpEvent(String eventId) => '/events/$eventId/rsvp';

  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
}
