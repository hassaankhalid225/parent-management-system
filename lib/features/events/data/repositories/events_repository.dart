import 'package:pms/core/network/api_endpoints.dart';
import 'package:pms/core/network/api_service.dart';
import 'package:pms/features/events/data/models/event_model.dart';

class EventsRepository {
  final ApiService _apiService;

  EventsRepository(this._apiService);

  Future<List<EventModel>> getEvents() async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) {
        return _getMockEvents();
      }

      final response = await _apiService.get(ApiEndpoints.events);
      if (response.statusCode == 200) {
        final List<dynamic> eventsData = response.data['events'];
        return eventsData.map((json) => EventModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load events');
      }
    } catch (e) {
      return _getMockEvents();
    }
  }

  Future<void> updateRsvp(String eventId, RsvpStatus status) async {
    try {
      if (ApiEndpoints.baseUrl.contains('api.pms-school.com')) return;
      await _apiService.post(
        ApiEndpoints.rsvpEvent(eventId),
        data: {'status': status.toString().split('.').last},
      );
    } catch (e) {
      // Ignore for mock mode
    }
  }

  List<EventModel> _getMockEvents() {
    final now = DateTime.now();
    return [
      EventModel(
        id: "ev_1",
        title: "Annual Sports Day",
        description: "Join us for our annual sports day competition.",
        date: DateTime(now.year, now.month, now.day + 2),
        startTime: "09:00 AM",
        endTime: "02:00 PM",
        location: "Main Ground",
        type: EventType.sports,
        organizer: "Physical Education Dept",
        isRsvpRequired: true,
      ),
      EventModel(
        id: "ev_2",
        title: "Parent-Teacher Meeting",
        description: "Quarterly progress review meeting.",
        date: DateTime(now.year, now.month, now.day + 5),
        startTime: "10:30 AM",
        endTime: "12:30 PM",
        location: "Respective Classrooms",
        type: EventType.meeting,
        organizer: "Principal Office",
        isRsvpRequired: true,
      ),
    ];
  }
}
