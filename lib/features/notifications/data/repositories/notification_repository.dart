import 'package:pms/core/network/api_endpoints.dart';
import 'package:pms/core/network/api_service.dart';
import 'package:pms/features/notifications/data/models/notification_model.dart';

class NotificationRepository {
  final ApiService _apiService;

  NotificationRepository(this._apiService);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockNotifications();
      }

      final response = await _apiService.get(ApiEndpoints.notifications);
      if (response.statusCode == 200) {
        final List<dynamic> notificationsData = response.data['notifications'];
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load notifications');
      }
    } catch (e) {
      return _getMockNotifications();
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) return;
      await _apiService.post(ApiEndpoints.markNotificationRead(id));
    } catch (e) {
      // Ignore for mock mode
    }
  }

  List<NotificationModel> _getMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: "nt_1",
        title: "Fee Reminder",
        message: "Tuition fee for January is due on Jan 15th.",
        timestamp: now.subtract(const Duration(hours: 2)),
        type: NotificationType.fee,
      ),
      NotificationModel(
        id: "nt_2",
        title: "New Diary Entry",
        message: "A new activity update for your child has been posted.",
        timestamp: now.subtract(const Duration(hours: 5)),
        type: NotificationType.diary,
        isRead: true,
      ),
    ];
  }
}
